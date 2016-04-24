# Bryce's dotfiles

### [You know the drill](https://dotfiles.github.io/)
Used to bootstrap a system. In this case my system.
- Installs homebrew
- Installs LastPass
- Syncs client SSH keys
- Installs zsh
- Installs any number of homebrew or homebrew-cask packages
- Symlinks my git config (easily swappable)
- Installs my git bin commands
- More coming soon!

### Prerequisites
First you should install [dropbox_uploader.sh](https://github.com/andreafabrizi/Dropbox-Uploader)
- Run through the setup once and save the keys found in ~/.dropbox-uploader into Lastpass
- You should follow the key structure laid out in `dotfiles/applications/.dropbox-uploader`

In your dropbox you should create a root folder names SSHKeys
- Create a subfolder called Hosts
    - This will contain a key per computer you run this on
    - I use this key for access control to servers in my domain
- Create a subfolder called Identities
    - This contains your ssh keys for services
    - I have GitHub and BitBucket keys right now, though probably more in the future

You should have an SSHKeys folder in LastPass for the private key encryption passwords

### Post clone steps
- Modify the the various install-environment parameters if they are non-default

### To Run
```
git clone https://github.com/brycekbargar/dotfiles.git && cd dotfiles

cp install-environment ../
sed -i '' 's/<your email>/<your actual email>/g' ../install-environment

# Do post clone steps

$(source ../install-environment && ./install.sh)
rm -f ../install-environment
```

### Caveats
- This works on my system (at least my various macs at varying points)
- It may work on your system, but I'm not looking to build yadr.
- I just want some way to keep all my dev systems consistent and to learn bash/git/zsh/everything else
