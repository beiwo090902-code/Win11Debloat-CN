function GetFriendlyTargetUserName {
    $target = GetTargetUserForAppRemoval

    switch ($target) {
        "AllUsers" { return "所有用户" }
        "CurrentUser" { return "当前用户" }
        default { return "用户 $target" }
    }
}
