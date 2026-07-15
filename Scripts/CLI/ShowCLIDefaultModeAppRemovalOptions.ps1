# Shows the CLI default mode app removal options. Loops until a valid option is selected.
function ShowCLIDefaultModeAppRemovalOptions {
    PrintHeader '默认模式'

    Write-Host "请注意：默认应用选择包含 Microsoft Teams、Spotify、便笺等。请选择选项 2 以查看并修改脚本将卸载的应用。" -ForegroundColor DarkGray
    Write-Host ""

    Do {
        Write-Host "选项：" -ForegroundColor Yellow
        Write-Host " (n) 不卸载任何应用" -ForegroundColor Yellow
        Write-Host " (1) 仅卸载默认选择的应用" -ForegroundColor Yellow
        Write-Host " (2) 手动选择要卸载的应用" -ForegroundColor Yellow
        $RemoveAppsInput = Read-Host "是否卸载应用？应用将为所有用户卸载 (n/1/2)"

        # Show app selection form if user entered option 3
        if ($RemoveAppsInput -eq '2') {
            $result = Show-AppSelectionWindow

            if ($result -ne $true) {
                # User cancelled or closed app selection, change RemoveAppsInput so the menu will be shown again
                Write-Host ""
                Write-Host "已取消应用选择，请重试。" -ForegroundColor Red

                $RemoveAppsInput = 'c'
            }
            
            Write-Host ""
        }
    }
    while ($RemoveAppsInput -ne 'n' -and $RemoveAppsInput -ne '0' -and $RemoveAppsInput -ne '1' -and $RemoveAppsInput -ne '2')

    return $RemoveAppsInput
}
