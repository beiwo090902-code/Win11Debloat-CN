# Show CLI default mode options for removing apps, or set selection if RunDefaults or RunDefaultsLite parameter was passed
function ShowCLIDefaultModeOptions {
    if ($RunDefaults) {
        $RemoveAppsInput = '1'
    }
    elseif ($RunDefaultsLite) {
        $RemoveAppsInput = '0'                
    }
    else {
        $RemoveAppsInput = ShowCLIDefaultModeAppRemovalOptions

        if ($RemoveAppsInput -eq '2' -and ($script:SelectedApps.contains('Microsoft.XboxGameOverlay') -or $script:SelectedApps.contains('Microsoft.XboxGamingOverlay')) -and 
          $( Read-Host -Prompt "是否关闭 Game Bar 集成和游戏/屏幕录制？这也会关闭 ms-gamingoverlay 和 ms-gamebar 弹窗 (Y/N)" ) -match '(?i)^(y|yes|是)$') {
            $DisableGameBarIntegrationInput = $true;
        }
    }

    PrintHeader '默认模式'

    try {
        # Select app removal options based on user input
        switch ($RemoveAppsInput) {
            '1' {
                AddParameter 'RemoveApps'
                AddParameter 'Apps' 'Default'
            }
            '2' {
                AddParameter 'RemoveApps'
                AddParameter 'Apps' ($script:SelectedApps -join ',')

                if ($DisableGameBarIntegrationInput) {
                    AddParameter 'DisableDVR'
                    AddParameter 'DisableGameBarIntegration'
                }
            }
        }

        LoadSettings -filePath $script:DefaultSettingsFilePath -expectedVersion "1.0"
    }
    catch {
        Write-Error "无法从 DefaultSettings.json 加载设置：$_"
        AwaitKeyToExit
    }

    SaveSettings

    if ($Silent) {
        # Skip change summary and confirmation prompt
        return
    }

    PrintPendingChanges
    PrintHeader '默认模式'
}
