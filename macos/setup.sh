#!/usr/bin/env bash
mkdir ~/.local
mkdir ~/.local/share
mkdir ~/.local/var
mkdir ~/.local/var/cache
mkdir ~/.local/var/lib
mkdir ~/.local/opt
mkdir ~/.local/opt/apps

/opt/local/bin/git clone -b "${DOTFILES_BRANCH:-main}" https://github.com/brycekbargar/dotfiles.git ~/_src/dotfiles
ln -s ~/_src/dotfiles/.zshenv ~/.zshenv

CONDA_MACOS="Miniconda3-latest-MacOSX-x86_64.sh"
if [ "$(uname -m)" = "arm64" ]; then
	CONDA_MACOS="Miniconda3-latest-MacOSX-arm64.sh"
fi

pushd /private/tmp
curl -O -fsSL "https://repo.anaconda.com/miniconda/$CONDA_MACOS"
popd

/bin/zsh "/private/tmp/$CONDA_MACOS" -b -s -p "$HOME/.local/share/conda/base"
/bin/zsh -s <<EOF
	source <(~/.local/share/conda/base/bin/conda shell.zsh hook)
	cd ~/_src/dotfiles
	conda env create --file environment.yml --quiet
	unsetopt HASH_CMDS
	hash -r
	./tea.sh
EOF
