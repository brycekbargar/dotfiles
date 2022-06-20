#!/usr/bin/env bash
sudo apt --yes install git zsh

git clone -b "${DOTFILES_BRANCH:-main}" https://github.com/brycekbargar/dotfiles.git ~/_src/dotfiles
ln -s ~/_src/dotfiles/HOME/dot_zshenv ~/.zshenv
mkdir -p ~/.config/zsh
echo '#!/usr/bin/zsh' > ~/.config/zsh/.zshrc
mkdir -p ~/.local/bin
mkdir -p ~/.local/share
mkdir -p ~/.local/state

pushd /tmp
	curl -O --proto '=https' --tlsv1.2 -sSf  https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
	bash Miniconda3-latest-Linux-x86_64.sh -b
popd

/usr/bin/zsh -c "~/miniconda3/bin/conda init zsh"
