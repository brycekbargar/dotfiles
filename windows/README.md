# Windows Setup

### Usage

##### In admin powershell

```powershell
Set-ExecutionPolicy RemoteSigned -Scope LocalMachine
```

##### In regular powershell

```powershell
irm get.scoop.sh | iex
scoop install git
scoop bucket add versions
scoop install pwsh-beta
```

##### In powershell 7

```powershell
git clone -b main https://github.com/brycekbargar/dotfiles.git $home\_src\dotfiles
Set-Location $home\_src\dotfiles\windows
.\setup.ps1
```

##### In cmd.exe

```batch
.\scoop\shims\pwsh.exe -noprofile -command "Install-Module PSReadLine -Force -SkipPublisherCheck -AllowPrerelease"
```
