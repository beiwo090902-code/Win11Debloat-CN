function Test-TargetUserName {
    param(
        [AllowNull()]
        [AllowEmptyString()]
        [string]$UserName
    )

    $normalizedUserName = if ($null -ne $UserName) { $UserName.Trim() } else { '' }

    if ([string]::IsNullOrWhiteSpace($normalizedUserName)) {
        return [PSCustomObject]@{
            IsValid = $false
            UserName = $normalizedUserName
            Message = '请输入用户名'
        }
    }

    if (Test-UserNameMatch -UserNameA $normalizedUserName -UserNameB $env:USERNAME) {
        return [PSCustomObject]@{
            IsValid = $false
            UserName = $normalizedUserName
            Message = '不能输入当前用户名，请改用当前用户选项'
        }
    }

    if (-not (CheckIfUserExists -userName $normalizedUserName)) {
        return [PSCustomObject]@{
            IsValid = $false
            UserName = $normalizedUserName
            Message = '未找到用户，请输入有效的用户名'
        }
    }

    return [PSCustomObject]@{
        IsValid = $true
        UserName = $normalizedUserName
        Message = "已找到用户：$normalizedUserName"
    }
}
