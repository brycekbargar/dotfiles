# Windows Setup

### Usage

```ps
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
irm get.scoop.sh | iex
scoop install git
git clone -b main https://github.com/brycekbargar/dotfiles.git $home\_src\dotfiles
Set-Location $home\_src\dotfiles
git checkout ansible-dotfiles
.\windows\setup.ps1
```
