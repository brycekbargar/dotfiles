#!/bin/sh
sudo apt --yes install git zsh
git clone https://github.com/brycekbargar/dotfiles.git ~/_src/dotfiles
ln -s ~/_src/dotfiles/HOME/dot_zshrc ~/.zshrc
curl --proto '=https' --tlsv1.2 -sSf  https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh | sh
/usr/bin/zsh -c "~/miniconda3/bin/conda init zsh"

