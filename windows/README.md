# Windows Setup

### Usage

```ps
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
irm get.scoop.sh | iex
scoop install git
git clone -b main https://github.com/brycekbargar/dotfiles.git ~\_src\dotfiles
Set-Location ~\_src\dotfiles\windows
.\setup.ps1
```
