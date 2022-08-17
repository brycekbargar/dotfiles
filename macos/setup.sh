#!/usr/bin/env bash
mkdir ~/.local
mkdir ~/.local/share
mkdir ~/.local/var
mkdir ~/.local/var/cache
mkdir ~/.local/var/lib
mkdir ~/.local/var/opt

git clone -b "${DOTFILES_BRANCH:-main}" https://github.com/brycekbargar/dotfiles.git ~/_src/dotfiles
ln -s ~/_src/dotfiles/.zshenv ~/.zshenv

local $conda_macos="Miniconda3-latest-MacOSX-x86_64.sh"
if [ "$(uname -m)" -eq "arm64" ]
then
	$conda_macos="Miniconda3-latest-MacOSX-arm64.sh"
fi

pushd /tmp
	curl -O -fsSL "https://repo.anaconda.com/miniconda/$conda_macos"
popd

/usr/bin/zsh "/tmp/$conda_macos" -b -s -p "~/.local/share/conda/base"
/usr/bin/zsh -s << EOF
	source <(~/.local/share/conda/base/bin/conda shell.zsh hook)
	cd ~/_src/dotfiles
	conda env create --file environment.yml --quiet
	./tea.sh
EOF

unset $conda_macos
