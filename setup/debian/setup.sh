#!/usr/bin/env bash
mkdir ~/.config
mkdir ~/.cache
mkdir ~/.local
mkdir ~/.local/share
mkdir ~/.local/state
mkdir ~/.local/bin

sudo apt --yes install git zsh
git clone -b "${DOTFILES_BRANCH:-main}" https://github.com/brycekbargar/dotfiles.git ~/_src/dotfiles
ln -s ~/_src/dotfiles/HOME/dot_zshenv ~/.zshenv
mkdir -p ~/.config/zsh
echo '#!/usr/bin/zsh' > ~/.config/zsh/.zshrc

pushd /tmp
	curl -O --proto '=https' --tlsv1.2 -sSf  https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
	bash Miniconda3-latest-Linux-x86_64.sh -b -p "$HOME/.local/share/conda"
popd

/usr/bin/zsh -c "$HOME/.local/share/conda/bin/conda init zsh"
