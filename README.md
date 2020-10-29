# Dotfiles (for debian on wsl)

### Usage

```sh
sudo apt update
sudo apt --yes install git

mkdir -p ~/_src
cd ~/_src
git clone https://github.com/brycekbargar/debian-dotfiles.git
cd debian-dotfiles

./src/install.sh
```