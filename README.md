# Bryce's dotfiles #

### [You know the drill][0] ###
I'm moving towards only using virtualbox/vagrant for development and not installing dev tools on my host machine.

I need a way to consistently setup a new unix environment:

1. Setting the shell to `zsh` and using my configurations
1. Copying my gitconfig and any `git-*` scripts I use
1. Installing `tmux` with my configurations
1. Installing `neovim` with my configurations

Right now these scrips work on bare Arch and CentOS installs (guest) and a bare OSX El Capitan install (host).  
`/shrug` I think(?) it's idempotent, but

Additionally for OSX (or any future host):

1. Downloading my identity SSH Keys (git, bitbucket, etc...)
1. Creating or downloading an SSH Key for the host to be whitelisted by guests I own
1. Installing various packages I use on a daily basis (chrome, sonos, iterm2, etc...)

##### Future Plans #####
- Support bash on windows as a host
- Configurations for ansible/vagrant as I get better at provisioning dev environments

### Customization ###

##### For Guests and Hosts #####

- Change the email in `src/utils/install-environment` to yours
- Swap out/modify/add to the configuration files located in the `dotfiles/folder`
  - .gitconfig and .tmux.conf work (mostly) as expected
  - Neovim uses [vim-plug][1] to load from this repo, point `dotfiles/nvim/init.vim` to your repo
  - Zsh mostly uses [antigen][2] to load from this repo, point `/dotfiles/zsh/.zshrc` to your repo

##### For Guests #####

If your guest is a relatively clean install of Arch or CentOS the install _should_ just work

If you want to add a new operating system as a guest

- Modify `src/utils/set-environment` to detect the OS and set the `$EVIRONMENT` variable
- Add a `src/$ENVIRONMENT` and a `dotfiles/zsh/$ENVIRONMENT` folder
- Add any environment specific steps and configuration to these folders using `**/arch/*` as an example

##### For Hosts #####

I manage my ssh-keys using a combination of dropbox and lastpass.  


First you should install [dropbox_uploader.sh][3]
- Run through the setup once and save the keys found in ~/.dropbox-uploader into Lastpass
- Follow the key structure laid out in `dotfiles/dropbox-uploader/.dropbox-uploader`

In your dropbox you should create a root folder names SSHKeys
- Create a subfolder called Hosts
    - This will contain a key per computer you run this on
    - I use this key so I can whitelist a "dev-machine" key and have it work regardless of whatever hardware I'm actually devving with
- Create a subfolder called Identities
    - This contains your ssh keys for services
    - I have GitHub and BitBucket keys right now, though probably more in the future

You'll need a folder in Lastpass called SSHKeys, were the password name is the same as the key name

Change `/src/osx/08-packages` to reflect the software you use on a regular basis
You should have an SSHKeys folder in LastPass for the private key encryption passwords

### Running ###
```
# vagrant only
sudo useradd -m -G wheel -U bryce
sudo passwd bryce
su - bryce
# end vagrant

git clone https://github.com/brycekbargar/dotfiles.git
./dotfiles/src/install.sh
```
[0]: https://dotfiles.github.io/ 
[1]: https://github.com/junegunn/vim-plug
[2]: https://github.com/zsh-users/antigen 
[3]: https://github.com/andreafabrizi/Dropbox-Uploader
