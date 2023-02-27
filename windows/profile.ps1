Import-Module PSReadLine
Set-PSReadLineOption -EditMode Vi
function OnViModeChange {
    if (    $args[0] -eq 'Command') {
        Write-Host -NoNewline "`e[1 q"
    }
    else {
        Write-Host -NoNewline "`e[5 q"
    }
}
Set-PSReadLineOption -ViModeIndicator Script -ViModeChangeHandler $Function:OnViModeChange
