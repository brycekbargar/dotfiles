# scoop buckets
& scoop bucket add extras
& scoop bucket add nerd-fonts
& scoop update
# scoop tools
& scoop install sudo
& scoop install 7zip
& "$HOME\scoop\apps\7zip\current\install-context.reg"
& scoop install aria2
& scoop config aria2-warning-enabled false
# scoop checkup
& scoop install innounp
& scoop install dark
& sudo Add-MpPreference -ExclusionPath "$HOME\scoop"
& sudo Add-MpPreference -ExclusionPath 'C:\ProgramData\scoop'
& sudo Set-ItemProperty 'HKLM:\SYSTEM\CurrentControlSet\Control\FileSystem' -Name 'LongPathsEnabled' -Value 1
& scoop cleanup *

# colemak
& scoop install .\colemak.json

# autohotkey
& scoop install autohotkey

# vscode
& scoop install vscode
& "$HOME\scoop\apps\vscode\current\install-associations.reg"

# windows terminal
& scoop install windows-terminal
& scoop install extras/vcredist2019
& sudo scoop install Cascadia-Code 
$df_terminal_settings = [System.IO.Path]::Combine("$PSScriptRoot", "terminal.json")
$ln_terminal_settings = [System.IO.Path]::Combine("$env:LOCALAPPDATA", "Packages", "Microsoft.WindowsTerminal_8wekyb3d8bbwe", "LocalState", "settings.json")
& sudo New-Item -Path "$ln_terminal_settings" -ItemType SymbolicLink -Value "$df_terminal_settings" -Force
$df_profile = [System.IO.Path]::Combine("$PSScriptRoot", "profile.ps1")
$ln_profile = [System.IO.Path]::Combine("$HOME", "Documents", "PowerShell", "profile.ps1")
& sudo New-Item -Path "$ln_profile" -ItemType SymbolicLink -Value "$df_profile" -Force

# vim
function LatestVimPlugin {
    param (
        $repo,
        $dest
    )
        if (-not (Test-Path "$dest")) {
            git clone --depth 1 --single-branch "$repo" "$dest"
        }
        else {
            Push-Location "$dest"
                git pull
            Pop-Location
        }
}
& scoop install vim
New-Item "~/vimfiles/state/backup" -ItemType Directory -Force
New-Item "~/vimfiles/state/swap" -ItemType Directory -Force
New-Item "~/vimfiles/state/undo" -ItemType Directory -Force
New-Item "~/vimfiles/pack/common" -ItemType Directory -Force
Push-Location "~/vimfiles/pack/common/"
    LatestVimPlugin "https://github.com/tpope/vim-sensible" "start/sensible"
    LatestVimPlugin "https://github.com/tpope/vim-vinegar" "start/vinegar"
    LatestVimPlugin "https://github.com/tpope/vim-sleuth" "start/sleuth"
    LatestVimPlugin "https://github.com/lifepillar/vim-mucomplete" "start/mucomplete"
    LatestVimPlugin "https://github.com/sheerun/vim-polyglot" "opt/polyglot"
    LatestVimPlugin "https://github.com/catppuccin/vim" "opt/catppuccin-vim"
    LatestVimPlugin "https://github.com/tpope/vim-flagship" "opt/flagship"
Pop-Location
$df_vimrc = [System.IO.Path]::Combine("$PSScriptRoot", "..", "XDG_CONFIG_HOME", "nvim", "init.vim")
$ln_vimrc = [System.IO.Path]::Combine("$HOME", "_vimrc")
& sudo New-Item -Path "$ln_vimrc" -ItemType SymbolicLink -Value "$df_vimrc" -Force

# wsl
& scoop install win32yank
& sudo wsl --update

# random stuff
& scoop install flux
git clone --depth 1 --single-branch https://github.com/catppuccin/wallpapers ~\Pictures\Catppuccin
