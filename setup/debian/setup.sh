#!/usr/bin/env bash
sudo apt --yes install git zsh

git clone https://github.com/brycekbargar/dotfiles.git ~/_src/dotfiles
ln -s ~/_src/dotfiles/HOME/dot_zshenv ~/.zshenv
mkdir -p ~/.config/zsh
echo "#!/usr/bin/zsh" > ~/.config/zsh/.zshrc

pushd /etc
	curl -O --proto '=https' --tlsv1.2 -sSf  https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
	bash Miniconda3-latest-Linux-x86_64.sh -b -p ~/miniconda3
popd /etc

/usr/bin/zsh -c "~/miniconda3/bin/conda init zsh"
/usr/bin/zsh -c "conda env create --file ~/_src/dotfiles/environment.yml"
/usr/bin/zsh -c "conda run -n dotfiles sudo apt install python3-apt"
