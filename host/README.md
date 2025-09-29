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
git clone -b main https://github.com/brycekbargar/dotfiles.git $home\dotfiles
Set-Location $home\dotfiles\host
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
  - Configure host networking for Docker Desktop
  - [Delugia Book](https://github.com/adam7/delugia-code/releases/latest)
  - Edit ~\\.gitconfig to link ~/dotfiles/host/gitconfig via https://stackoverflow.com/a/9733277
