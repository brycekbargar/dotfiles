# Debian Setup (on wsl2)

### Usage

```sh
sudo apt update
sudo apt --yes install curl

curl --proto '=https' --tlsv1.2 -sSf  https://raw.githubusercontent.com/brycekbargar/dotfiles/main/setup/debian/setup.sh | sh

exec zsh
cd ~/_src/dotfiles
conda activate dotfiles

sudo apt install python3-apt
ansible-playbook playbooks/home.playbook.yml
```

