<#
.Synopsis
List the contents of the provided path regardless of type
.Description
Calls either Get-ChildItem or Get-Content depending on the pyte of item
#>
function Get-ChildContent {
    param (
        [String]$Path = "."
    )
    if((Get-Item -Path $Path).PSIsContainer) {
        Get-ChildItem -Force -Path $Path
        return
    }
    Get-Content -Path $Path | Out-Host -Paging
}
Set-Alias -Name lss -Value Get-ChildContent

<#
.Synopsis
Makes sure the pwsh container exists for nvim
.Description
Will basically always just build a new one with :latest tag
The build context is whereever this runs but that doesn't really matter
#>
function Initialize-PwshContainer {
    $dateTag = Get-Date -Format "MM-dd-yy"
    &docker build `
        --no-cache `
        -t "brycekbargar.com/pwsh:latest" `
        -t "brycekbargar.com/pwsh:$dateTag" `
        -f "$HOME\dotfiles\XDG_CONFIG_HOME\nvim\Dockerfile.pwsh" `
        .
}
