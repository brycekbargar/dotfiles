# Debian Setup (on wsl2)

### Usage

```bash
sudo apt update
sudo apt install curl --yes
export DOTFILES_BRANCH=ansible-rewrite && curl --proto '=https' --tlsv1.2 -sSf  https://raw.githubusercontent.com/brycekbargar/dotfiles/"$DOTFILES_BRANCH"/debian/setup.sh | bash
```

