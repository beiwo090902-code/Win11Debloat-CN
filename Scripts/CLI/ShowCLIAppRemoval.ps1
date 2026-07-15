# Shows the CLI app removal menu and prompts the user to select which apps to remove.
function ShowCLIAppRemoval {
    PrintHeader "应用卸载"

    Write-Output "> 正在打开应用选择窗口..."

    $result = Show-AppSelectionWindow

    if ($result -eq $true) {
        Write-Output "已选择卸载 $($script:SelectedApps.Count) 个应用。"
        AddParameter 'RemoveApps'
        AddParameter 'Apps' ($script:SelectedApps -join ',')

        SaveSettings

        # Suppress prompt if Silent parameter was passed
        if (-not $Silent) {
            Write-Output ""
            Write-Output ""
            Write-Output "按 Enter 卸载所选应用，或按 Ctrl+C 退出..."
            Read-Host | Out-Null
            PrintHeader "应用卸载"
        }
    }
    else {
        Write-Host "已取消选择，未卸载任何应用。" -ForegroundColor Red
        Write-Output ""
    }
}
