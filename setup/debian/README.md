# Debian Setup (on wsl2)

### Usage

```bash
sudo apt update; sudo apt install curl --yes
curl --proto '=https' --tlsv1.2 -sSf  https://raw.githubusercontent.com/brycekbargar/dotfiles/main/setup/debian/setup.sh | bash

exec zsh
cd ~/_src/dotfiles
conda activate dotfiles

ansible-playbook playbooks/home.playbook.yml
```

