# Windows Setup

### Usage

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
git clone -b main https://github.com/brycekbargar/dotfiles.git $home\_src\dotfiles
Set-Location $home\_src\dotfiles\windows
.\setup.ps1
```

##### In cmd.exe

```batch
.\scoop\shims\pwsh.exe -noprofile -command "Install-Module PSReadLine -Force -SkipPublisherCheck -AllowPrerelease"
```
