# Bryce's dotfiles

### [You know the drill](https://dotfiles.github.io/)
Used to bootstrap a system. In this case my system.
- Installs packer
- Installs homebrew and homebrew-cask
- Installs LastPass
- Syncs client SSH keys
- Installs zsh
- Installs any number of pacman or AUR packages
- Installs any number of homebrew or homebrew-cask packages
- More coming soon!

### Prerequisites
First you should install [dropbox_uploader.sh](https://github.com/andreafabrizi/Dropbox-Uploader)
- Run through the setup once and save the keys found in ~/.dropbox-uploader into Lastpass
- You should follow the key structure laid out in dotfiles/applications/.dropbox-uploader

In your dropbox you should create a root folder names SSHKeys
- Create a subfolder called Hosts
    - This will contain a key per computer you run this on
    - I use this key for access control to servers in my domain
- Create a subfolder called Identities
    - This contains your ssh keys for services
    - I have GitHub and BitBucket keys right now, though probably more in the future

You should also have the same folder/naming structure in LastPass for the private key encryption password

Modify `src/package-management/environment-specific-packages` to include your favorite packages


### To Run
```
export LASTPASS_USERNAME=<your username>
git clone https://github.com/brycekbargar/dotfiles.git
cd dotfiles
chmod +x install.sh
./install.sh
```
