# scoop buckets
& scoop bucket add extras
& scoop bucket add nerd-fonts
& scoop update
# scoop tools
& scoop install 7zip
& scoop install sudo
& scoop install aria2
# scoop checkup
& scoop install innounp
& sudo Add-MpPreference -ExclusionPath "$HOME\scoop"
& sudo Add-MpPreference -ExclusionPath 'C:\ProgramData\scoop'
& sudo Set-ItemProperty 'HKLM:\SYSTEM\CurrentControlSet\Control\FileSystem' -Name 'LongPathsEnabled' -Value 1
& scoop cleanup *

# colemak
& scoop install Resolve-Path ([System.IO.Path]::Combine($PSScriptRoot, "scoop", "colemak.json")

# autohotkey
& scoop install autohotkey
& scoop install Resolve-Path ([System.IO.Path]::Combine($PSScriptRoot, "scoop", "autohotkey-shim.json")

# vscode
& scoop install vscode
& "$HOME\scoop\apps\vscode\current\vscode-install-context.reg"

# windows terminal
& scoop install pwsh
& scoop install windows-terminal
& scoop install extras/vcredist2019
& sudo scoop install Cascadia-Code 
$df_terminal_settings = Resolve-Path ([System.IO.Path]::Combine($PSScriptRoot, "terminal.json"))
$ln_terminal_settings = Resolve-Path ([System.IO.Path]::Combine("$env:LOCALAPPDATA", "Microsoft", "Windows Terminal", "settings.json"))
& sudo New-Item -Path "$ln_terminal_settings" -ItemType SymbolicLink -Value "$df_terminal_settings" -Force
Install-Module PSReadLine -AllowPrerelease -Force

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
New-Item "~/.vim/state/backup" -ItemType Directory -Force
New-Item "~/.vim/state/swap" -ItemType Directory -Force
New-Item "~/.vim/state/undo" -ItemType Directory -Force
New-Item "~/.vim/pack/common" -ItemType Directory -Force
Push-Location "~/.vim/pack/common/"
    LatestVimPlugin "https://github.com/tpope/vim-sensible" "start/sensible"
    LatestVimPlugin "https://github.com/tpope/vim-vinegar" "start/vinegar"
    LatestVimPlugin "https://github.com/tpope/vim-sleuth" "start/sleuth"
    LatestVimPlugin "https://github.com/lifepillar/vim-mucomplete" "start/mucomplete"
    LatestVimPlugin "https://github.com/sheerun/vim-polyglot" "opt/polyglot"
    LatestVimPlugin "https://github.com/catppuccin/vim" "opt/catppuccin-vim"
    LatestVimPlugin "https://github.com/tpope/vim-flagship" "opt/flagship"
Pop-Location
$df_vimrc = Resolve-Path ([System.IO.Path]::Combine($PSScriptRoot, ".." "XDG_CONFIG_HOME", "nvim", "init.vim"))
$ln_vimrc = Resolve-Path ("~/.vim/vimrc")
& sudo New-Item -Path $ln_vimrc -ItemType SymbolicLink -Value df_vimrc -Force

# wsl
& scoop install win32yank
& sudo wsl --install --distribution Debian

