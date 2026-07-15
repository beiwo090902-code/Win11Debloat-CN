# Saves the current settings, excluding control parameters, to 'LastUsedSettings.json' file
function SaveSettings {
    if ($script:Params.ContainsKey("WhatIf")) {
        Write-Host "[WhatIf] 将设置保存到 LastUsedSettings.json" -ForegroundColor Cyan
        return
    }

    $settings = @{
        "Version" = "1.0"
        "Settings" = @()
    }
    
    foreach ($param in $script:Params.Keys) {
        if ($script:ControlParams -notcontains $param -and $script:Features.ContainsKey($param)) {
            $value = $script:Params[$param]

            $settings.Settings += @{
                "Name" = $param
                "Value" = $value
            }
        }
    }

    if (-not (SaveToFile -Config $settings -FilePath $script:SavedSettingsFilePath)) {
        Write-Output ""
        Write-Host "错误：无法将设置保存到 LastUsedSettings.json 文件" -ForegroundColor Red
    }
}
