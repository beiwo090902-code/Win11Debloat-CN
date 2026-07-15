# Shows the CLI last used settings from LastUsedSettings.json file, displays pending changes and prompts the user to apply them.
function ShowCLILastUsedSettings {
    PrintHeader '自定义模式'

    try {
        LoadSettings -filePath $script:SavedSettingsFilePath -expectedVersion "1.0"
    }
    catch {
        Write-Error "无法从 LastUsedSettings.json 加载设置：$_"
        AwaitKeyToExit
    }

    if ($Silent) {
        # Skip change summary and confirmation prompt
        return
    }

    PrintPendingChanges
    PrintHeader '自定义模式'
}
