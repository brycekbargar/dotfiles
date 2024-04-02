# Host Setup

### Windows Usage

First undo: https://devblogs.microsoft.com/commandline/windows-terminal-is-now-the-default-in-windows-11/

##### In admin powershell

```powershell
Set-ExecutionPolicy RemoteSigned -Scope LocalMachine
```

##### In regular powershell

```powershell
irm get.scoop.sh | iex
scoop install pwsh
```

##### In powershell 7

```powershell
scoop install git
git clone -b main https://github.com/brycekbargar/dotfiles.git $home\_setup\dotfiles
Set-Location $home\_setup\dotfiles\host
.\setup.ps1
```

##### In cmd.exe

```batch
.\scoop\shims\pwsh.exe -noprofile -command "Install-Module PSReadLine -Force -SkipPublisherCheck -AllowPrerelease"
.\scoop\shims\pwsh.exe -noprofile -command "Install-Module posh-git -Force -SkipPublisherCheck -AllowPrerelease"
```

##### Install Manually
  - WSL: `wsl --install --no-distribution --no-launch` with a couple of restarts if it hangs
  - [Docker Desktop](https://docs.docker.com/desktop/install/windows-install/)
  - [Delugia Book](https://github.com/adam7/delugia-code/releases/latest)
  - Edit ~\\.gitconfig to link ~/_setup/dotfiles/host/gitconfig via https://stackoverflow.com/a/9733277

### Macos Usage

##### Install Manuall
1. xcode: `xcode-select --install`
1. [Homebrew](https://github.com/Homebrew/brew/releases/latest)
1. [kitty](https://github.com/kovidgoyal/kitty/releases/latest)
1. [Delugia Book](https://github.com/adam7/delugia-code/releases/latest) using Font Book

##### In kitty.app

```sh
eval "$(/opt/homebrew/bin/brew shellenv)"
brew install git
git clone -b main https://github.com/brycekbargar/dotfiles.git ~/_setup/dotfiles
cd ~/_setup/dotfiles/host
./setup.sh
```
