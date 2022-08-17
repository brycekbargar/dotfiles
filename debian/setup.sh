#!/usr/bin/env bash
mkdir ~/.local
mkdir ~/.local/share
mkdir ~/.local/var
mkdir ~/.local/var/cache
mkdir ~/.local/var/lib
mkdir ~/.local/opt

sudo apt --yes install git zsh
git clone -b "${DOTFILES_BRANCH:-main}" https://github.com/brycekbargar/dotfiles.git ~/_src/dotfiles
ln -s ~/_src/dotfiles/.zshenv ~/.zshenv

pushd /tmp
	curl -O --proto '=https' --tlsv1.2 -sSf  https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
popd

/usr/bin/zsh /tmp/Miniconda3-latest-Linux-x86_64.sh -b -s -p "~/.local/share/conda/base"
/usr/bin/zsh -s << EOF
	source <(~/.local/share/conda/base/bin/conda shell.zsh hook)
	cd ~/_src/dotfiles
	conda env create --file environment.yml --quiet
	./tea.sh
EOF
