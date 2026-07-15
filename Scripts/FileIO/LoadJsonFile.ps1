# Loads a JSON file from the specified path and returns the parsed object
# Returns $null if the file doesn't exist or if parsing fails
function LoadJsonFile {
    param (
        [string]$filePath,
        [string]$expectedVersion = $null,
        [switch]$optionalFile
    )
    
    if (-not (Test-Path $filePath)) {
        if (-not $optionalFile) {
            Write-Error "未找到文件：$filePath"
        }
        return $null
    }
    
    try {
        $jsonContent = Get-Content -Path $filePath -Raw | ConvertFrom-Json

        if ($script:FeaturesFilePath -and (Get-Command ConvertTo-LocalizedFeatureConfig -ErrorAction SilentlyContinue)) {
            $inputPath = [System.IO.Path]::GetFullPath($filePath)
            $featuresPath = [System.IO.Path]::GetFullPath($script:FeaturesFilePath)
            if ($inputPath -ieq $featuresPath) {
                $jsonContent = ConvertTo-LocalizedFeatureConfig -Config $jsonContent
            }
        }
        
        # Validate version if specified
        if ($expectedVersion -and $jsonContent.Version -and $jsonContent.Version -ne $expectedVersion) {
            Write-Error "$(Split-Path $filePath -Leaf) 版本不匹配（期望 $expectedVersion，实际为 $($jsonContent.Version)）"
            return $null
        }
        
        return $jsonContent
    }
    catch {
        Write-Error "无法解析 JSON 文件：$filePath"
        return $null
    }
}
