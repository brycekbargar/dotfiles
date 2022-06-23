#!/usr/bin/env bash
mkdir -p ~/.local/var
mkdir -p ~/.local/etc
mkdir ~/.local/share
mkdir ~/.local/etc/zsh
mkdir ~/.local/etc/conda
mkdir ~/.local/var/cache
mkdir ~/.local/var/lib
mkdir ~/.local/bin

sudo apt --yes install git zsh
git clone -b "${DOTFILES_BRANCH:-main}" https://github.com/brycekbargar/dotfiles.git ~/_src/dotfiles
ln -s ~/_src/dotfiles/HOME/dot_zshenv ~/.zshenv
cat > ~/.local/etc/zsh/.zshrc << EOF
#!/usr/bin/zsh
EOF
cp ~/_src/dotfiles/XDG_CONFIG_HOME/conda/.condarc ~/.local/etc/conda/.condarc

pushd /tmp
	curl -O --proto '=https' --tlsv1.2 -sSf  https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
popd

/usr/bin/zsh /tmp/Miniconda3-latest-Linux-x86_64.sh -b -s -p "~/.local/share/conda"
/usr/bin/zsh -s << EOF
	~/.local/share/conda/bin/conda init zsh
	source ~/.local/etc/zsh/.zshrc
	conda env create --file ~/_src/dotfiles/environment.yml --quiet
EOF
