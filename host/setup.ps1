# scoop buckets
& scoop bucket add extras
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
$df_terminal_settings = [System.IO.Path]::Combine("$PSScriptRoot", "terminal.json")
$ln_terminal_settings = [System.IO.Path]::Combine("$env:LOCALAPPDATA", "Packages", "Microsoft.WindowsTerminal_8wekyb3d8bbwe", "LocalState", "settings.json")
& sudo New-Item -Path "$ln_terminal_settings" -ItemType SymbolicLink -Value "$df_terminal_settings" -Force
$df_profile = [System.IO.Path]::Combine("$PSScriptRoot", "profile.ps1")
$ln_profile = [System.IO.Path]::Combine("$HOME", "Documents", "PowerShell", "profile.ps1")
& sudo New-Item -Path "$ln_profile" -ItemType SymbolicLink -Value "$df_profile" -Force

# vim
& scoop install vim
New-Item "~/vimfiles/state/backup" -ItemType Directory -Force
New-Item "~/vimfiles/state/swap" -ItemType Directory -Force
New-Item "~/vimfiles/state/undo" -ItemType Directory -Force
New-Item "~/vimfiles/pack/common" -ItemType Directory -Force
Push-Location "~/vimfiles/pack/common/"
git clone --depth 1 --single-branch "$repo" "https://github.com/tpope/vim-sensible" "start/sensible"
git clone --depth 1 --single-branch "$repo" "https://github.com/tpope/vim-vinegar" "start/vinegar"
git clone --depth 1 --single-branch "$repo" "https://github.com/tpope/vim-sleuth" "start/sleuth"
git clone --depth 1 --single-branch "$repo" "https://github.com/lifepillar/vim-mucomplete" "start/mucomplete"
git clone --depth 1 --single-branch "$repo" "https://github.com/sheerun/vim-polyglot" "opt/polyglot"
git clone --depth 1 --single-branch "$repo" "https://github.com/catppuccin/vim" "opt/catppuccin-vim"
git clone --depth 1 --single-branch "$repo" "https://github.com/tpope/vim-flagship" "opt/flagship"
Pop-Location
$df_vimrc = [System.IO.Path]::Combine("$PSScriptRoot", "..", "XDG_CONFIG_HOME", "nvim", "init.vim")
$ln_vimrc = [System.IO.Path]::Combine("$HOME", "_vimrc")
& sudo New-Item -Path "$ln_vimrc" -ItemType SymbolicLink -Value "$df_vimrc" -Force

# Modules
$currentPath = [Environment]::GetEnvironmentVariable('PSModulePath', 'USER')
if (-not $currentPath.Contains("dotfiles\windows\modules")) {
    $modules = Resolve-Path([System.IO.Path]::Combine($PSScriptRoot, "bin"))
    [Environment]::SetEnvironmentVariable('PSModulePath', "$currentPath;$modules" , 'USER')
}

# random stuff
Update-Help -UICulture en-Us -ErrorAction SilentlyContinue
& scoop install flux
& scoop install windirstat
& sudo wsl --update
New-Item "~/_setup/private" -ItemType Directory -Force
