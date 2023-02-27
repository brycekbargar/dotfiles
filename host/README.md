# Host Setup

### Macos Usage

### Windows Usage

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
Set-Location $home\_setup\dotfiles\windows
.\setup.ps1
```

##### In cmd.exe

```batch
.\scoop\shims\pwsh.exe -noprofile -command "Install-Module PSReadLine -Force -SkipPublisherCheck -AllowPrerelease"
.\scoop\shims\pwsh.exe -noprofile -command "Install-Module posh-git -Force -SkipPublisherCheck -AllowPrerelease"
```

##### Install Manually
  - Docker Desktop: https://docs.docker.com/desktop/install/windows-install/
  - Caskaydia Cove: https://github.com/ryanoasis/nerd-fonts/tree/master/patched-fonts/CascadiaCode
