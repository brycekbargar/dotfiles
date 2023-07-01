Import-Module posh-git

Import-Module PSReadLine
Set-PSReadLineOption -EditMode Vi
Function OnViModeChange {
    if (    $args[0] -eq 'Command') {
        Write-Host -NoNewline "`e[1 q"
    }
    else {
        Write-Host -NoNewline "`e[5 q"
    }
}
Set-PSReadLineOption -ViModeIndicator Script -ViModeChangeHandler $Function:OnViModeChange

Function ripgrep_smartcase {rg.exe --smart-case @args}
Set-Alias -Name rg -Value ripgrep_smartcase
