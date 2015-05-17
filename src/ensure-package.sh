#!/bin/bash
#
# Installs the requested packege if available
#
# Arguments $1 package-name $2 additional-package-source
#
# TODO: figure out how to handle additional package sources

if [ -z "$1" ]; then
	exit 1
fi

case "$PACKAGE_MANAGER" in
    "pacman")
		pacman -Syu
		packer -Syu
        if [ $(pacman -Ss $1 | grep '/$1 ') ]; then
        	echo "Installing $1 from pacman"
        	pacman -S $1
        	exit 0
        fi
        if [ $(packer -Ss $1 | grep '/$1 ') ]; then
        	echo "Installing $1 from packer"
        	packer -S $1
        	exit 0
        fi 
    ;;
    "homebrew")
		brew update && brew upgrade brew-cask && brew cleanup && brew cask cleanup
		if [ $(brew search $1 | grep $1) ]; then
			
			if [ $(brew list | grep $1) ]; then
				echo "Upgrading $1 from homebrew"
        		brew upgrade $1
        	else
        		echo "Installing $1 from homebrew"
        		brew install $1	
			fi
        	
        	exit 0
        fi
        if [ $(brew cask search $1 | grep $1) ]; then
        	
        	if [ $(brew cask list | grep $1) ]; then
				echo "Upgrading $1 from homebrew cask"
        		brew cask install --force $1
        	else
        		echo "Installing $1 from homebrew cask"
        		brew cask install $1	
			fi
        	
        	exit 0
        fi 
    ;;
    *)
		echo 'We dont know what $PACKAGE_MANAGER you are using!'
        exit 1
    ;;
esac


echo "We couldn't find $1 using $PACKAGE_MANAGER!"
exit 1