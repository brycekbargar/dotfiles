#!/usr/bin/env bash
mkdir ~/.local
mkdir ~/.local/etc
mkdir ~/.local/share
mkdir ~/.local/var
mkdir ~/.local/var/cache
mkdir ~/.local/var/lib
mkdir ~/.local/bin

sudo apt --yes install git zsh
git clone -b "${DOTFILES_BRANCH:-main}" https://github.com/brycekbargar/dotfiles.git ~/_src/dotfiles
ln -s ~/_src/dotfiles/.zshenv ~/.zshenv
cp ~/_src/dotfiles/XDG_CONFIG_HOME/.condarc ~/.local/etc/.condarc

pushd /tmp
	curl -O --proto '=https' --tlsv1.2 -sSf  https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
popd

/usr/bin/zsh /tmp/Miniconda3-latest-Linux-x86_64.sh -b -s -p "$CONDA_BASE"
/usr/bin/zsh -s << EOF
	mkdir ~/.local/etc/zsh
	touch ~/.local/etc/zsh/.zshrc
	$CONDA_BASE/bin/conda init zsh
	source ~/.local/etc/zsh/.zshrc
	conda env create --file ~/_src/dotfiles/environment.yml --quiet
EOF
