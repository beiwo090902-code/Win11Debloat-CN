# Loads and applies the optional Simplified Chinese display-text resource.
function Initialize-Localization {
    param (
        [string]$ResourcePath = $script:LocalizationResourcePath
    )

    $script:LocalizedStrings = @{}

    if (-not $ResourcePath -or -not (Test-Path $ResourcePath)) {
        return
    }

    try {
        $resource = Import-PowerShellDataFile -Path $ResourcePath
        if ($resource) {
            foreach ($mapName in @('Strings', 'StringsA', 'StringsB')) {
                if (-not $resource.ContainsKey($mapName) -or -not $resource[$mapName]) {
                    continue
                }

                foreach ($entry in $resource[$mapName].GetEnumerator()) {
                    $script:LocalizedStrings[$entry.Key] = $entry.Value
                }
            }
        }
    }
    catch {
        Write-Warning "无法加载中文本地化资源：$($_.Exception.Message)"
    }
}

function ConvertTo-LocalizedText {
    param (
        [AllowNull()]
        [string]$Text
    )

    if ($null -eq $Text -or -not $script:LocalizedStrings) {
        return $Text
    }

    if ($script:LocalizedStrings.ContainsKey($Text)) {
        return [string]$script:LocalizedStrings[$Text]
    }

    return $Text
}

function ConvertTo-LocalizedFeatureConfig {
    param (
        [Parameter(Mandatory = $true)]
        [object]$Config
    )

    if ($Config.Categories) {
        foreach ($category in $Config.Categories) {
            if ($category -is [string]) {
                continue
            }

            $displayName = ConvertTo-LocalizedText -Text $category.Name
            $category | Add-Member -NotePropertyName DisplayName -NotePropertyValue $displayName -Force
        }
    }

    if ($Config.UiGroups) {
        foreach ($group in $Config.UiGroups) {
            foreach ($propertyName in @('Label', 'ToolTip')) {
                if ($null -ne $group.$propertyName) {
                    $group.$propertyName = ConvertTo-LocalizedText -Text $group.$propertyName
                }
            }

            if ($group.Values) {
                foreach ($value in $group.Values) {
                    if ($null -ne $value.Label) {
                        $value.Label = ConvertTo-LocalizedText -Text $value.Label
                    }
                }
            }
        }
    }

    if ($Config.Features) {
        foreach ($feature in $Config.Features) {
            foreach ($propertyName in @('Label', 'ToolTip', 'ApplyText', 'UndoLabel', 'ApplyUndoText')) {
                if ($null -ne $feature.$propertyName) {
                    $feature.$propertyName = ConvertTo-LocalizedText -Text $feature.$propertyName
                }
            }
        }
    }

    return $Config
}
