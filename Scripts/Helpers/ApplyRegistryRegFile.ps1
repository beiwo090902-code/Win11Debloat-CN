function Get-NormalizedRegistryValueName {
    param(
        [AllowNull()]
        $ValueName
    )

    if ([string]::IsNullOrEmpty([string]$ValueName)) {
        return ''
    }

    return [string]$ValueName
}

function Convert-RegOperationToValueKind {
    param(
        [Parameter(Mandatory)]
        $Operation
    )

    $valueName = if ([string]::IsNullOrEmpty([string]$Operation.ValueName)) { '' } else { [string]$Operation.ValueName }
    $valueType = [string]$Operation.ValueType
    $operationKeyPath = [string]$Operation.KeyPath

    switch ($valueType) {
        'DWord' {
            $unsigned = [uint32]$Operation.ValueData
            $value = [BitConverter]::ToInt32([BitConverter]::GetBytes($unsigned), 0)
            return @{ Name = $valueName; Kind = [Microsoft.Win32.RegistryValueKind]::DWord; Value = $value }
        }
        'String' {
            return @{ Name = $valueName; Kind = [Microsoft.Win32.RegistryValueKind]::String; Value = [string]$Operation.ValueData }
        }
        'Binary' {
            return @{ Name = $valueName; Kind = [Microsoft.Win32.RegistryValueKind]::Binary; Value = [byte[]]$Operation.ValueData }
        }
        default {
            throw "应用 '$operationKeyPath' 的注册表操作时，不支持值类型 '$valueType'"
        }
    }
}

function Remove-RegistrySubKeyTreeIfExists {
    param(
        [Parameter(Mandatory)]
        [Microsoft.Win32.RegistryKey]$RootKey,
        [Parameter(Mandatory)]
        [string]$SubKeyPath
    )

    try {
        $RootKey.DeleteSubKeyTree($SubKeyPath, $false)
    }
    catch [System.UnauthorizedAccessException], [System.Security.SecurityException] {
        throw
    }
    catch {
        # Best-effort cleanup only; missing keys are fine.
    }
}

function Get-RegistryKeyForOperation {
    param(
        [Parameter(Mandatory)]
        [string]$RegistryPath,
        [switch]$CreateIfMissing,
        [bool]$OpenKey = $true
    )

    $parts = Split-RegistryPath -path $RegistryPath
    if (-not $parts) {
        throw "不支持的注册表路径：$RegistryPath"
    }

    $rootKey = Get-RegistryRootKey -hiveName $parts.Hive
    if (-not $rootKey) {
        throw "路径 '$RegistryPath' 中包含不支持的注册表配置单元 '$($parts.Hive)'"
    }

    $subKeyPath = $parts.SubKey
    if ([string]::IsNullOrWhiteSpace($subKeyPath)) {
        return [PSCustomObject]@{ RootKey = $rootKey; SubKeyPath = $null; Key = $rootKey }
    }

    if (-not $OpenKey) {
        return [PSCustomObject]@{ RootKey = $rootKey; SubKeyPath = $subKeyPath; Key = $null }
    }

    $key = if ($CreateIfMissing) {
        $rootKey.CreateSubKey($subKeyPath)
    }
    else {
        $rootKey.OpenSubKey($subKeyPath, $true)
    }

    return [PSCustomObject]@{ RootKey = $rootKey; SubKeyPath = $subKeyPath; Key = $key }
}

function Invoke-RegistryDeleteValueOperation {
    param(
        [Parameter(Mandatory)]
        $Operation,
        [Parameter(Mandatory)]
        $KeyInfo
    )

    if ($null -eq $KeyInfo.Key) {
        $valueName = Get-NormalizedRegistryValueName -ValueName $Operation.ValueName
        $displayValueName = if ([string]::IsNullOrEmpty($valueName)) { '(Default)' } else { $valueName }
        Write-Verbose "无法找到或打开注册表键 '$($Operation.KeyPath)' 及其值 '$displayValueName'"
        return
    }

    try {
        $valueName = Get-NormalizedRegistryValueName -ValueName $Operation.ValueName
        $KeyInfo.Key.DeleteValue($valueName, $false)
    }
    finally {
        $KeyInfo.Key.Close()
    }
}

function Invoke-RegistrySetValueOperation {
    param(
        [Parameter(Mandatory)]
        $Operation,
        [Parameter(Mandatory)]
        $KeyInfo
    )

    if ($null -eq $KeyInfo.Key) {
        throw [System.UnauthorizedAccessException]::new("无法打开或创建注册表键 '$($Operation.KeyPath)'")
    }

    try {
        $setArgs = Convert-RegOperationToValueKind -Operation $Operation
        $KeyInfo.Key.SetValue($setArgs.Name, $setArgs.Value, $setArgs.Kind)
    }
    finally {
        $KeyInfo.Key.Close()
    }
}

function Write-RegistryOperationAccessDeniedWarning {
    param(
        [Parameter(Mandatory)]
        $Operation,
        [Parameter(Mandatory)]
        [string]$ExceptionMessage
    )

    $keyPath = [string]$Operation.KeyPath
    $operationType = [string]$Operation.OperationType

    if ($operationType -eq 'SetValue' -or $operationType -eq 'DeleteValue') {
        $valueName = Get-NormalizedRegistryValueName -ValueName $Operation.ValueName
        $displayValueName = if ([string]::IsNullOrEmpty($valueName)) { '(Default)' } else { $valueName }
        Write-Warning "由于访问受限，已跳过对注册表键 '$keyPath' 值 '$displayValueName' 执行的 '$operationType' 操作：$ExceptionMessage"
        return
    }

    Write-Warning "由于访问受限，已跳过对注册表键 '$keyPath' 执行的 '$operationType' 操作：$ExceptionMessage"
}

function Invoke-RegistryOperation {
    param(
        [Parameter(Mandatory)]
        $Operation,
        [Parameter(Mandatory)]
        [string]$RegFilePath
    )

    $operationType = [string]$Operation.OperationType
    $isSetValueOperation = $operationType -eq 'SetValue'
    $isDeleteKeyOperation = $operationType -eq 'DeleteKey'

    $keyInfo = Get-RegistryKeyForOperation -RegistryPath $Operation.KeyPath -CreateIfMissing:$isSetValueOperation -OpenKey:(-not $isDeleteKeyOperation)

    switch ($operationType) {
        'DeleteKey' {
            if ($null -ne $keyInfo.SubKeyPath) {
                Remove-RegistrySubKeyTreeIfExists -RootKey $keyInfo.RootKey -SubKeyPath $keyInfo.SubKeyPath
            }
        }
        'DeleteValue' {
            Invoke-RegistryDeleteValueOperation -Operation $Operation -KeyInfo $keyInfo
        }
        'SetValue' {
            Invoke-RegistrySetValueOperation -Operation $Operation -KeyInfo $keyInfo
        }
        default {
            throw "'$RegFilePath' 中包含不支持的注册表操作类型 '$($Operation.OperationType)'"
        }
    }
}

function Invoke-RegistryOperationsFromRegFile {
    param(
        [Parameter(Mandatory)]
        [string]$RegFilePath
    )

    $accessDeniedCount = 0
    $operations = @(Get-RegFileOperations -regFilePath $RegFilePath)
    $totalOperations = $operations.Count

    if ($script:Params.ContainsKey("WhatIf")) {
        Write-Host "[WhatIf] 将从 '$RegFilePath' 应用 $totalOperations 项注册表更改" -ForegroundColor Cyan
        return
    }

    foreach ($operation in $operations) {
        try {
            Invoke-RegistryOperation -Operation $operation -RegFilePath $RegFilePath
        }
        catch [System.UnauthorizedAccessException], [System.Security.SecurityException] {
            $accessDeniedCount++
            Write-RegistryOperationAccessDeniedWarning -Operation $operation -ExceptionMessage $_.Exception.Message
        }
    }

    if ($totalOperations -gt 0 -and $accessDeniedCount -eq $totalOperations) {
        throw "注册表回退导入无法应用 '$RegFilePath' 中的任何操作，因为全部 $accessDeniedCount 项操作均因访问受限而被阻止。"
    }

    if ($accessDeniedCount -gt 0) {
        Write-Warning "注册表回退导入已完成，'$RegFilePath' 中有 $accessDeniedCount 项因访问受限而被跳过。"
    }
}
