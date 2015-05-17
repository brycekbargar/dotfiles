#!/bin/bash
#
# Ensures that the distros package manager is installed
# Ensures that additional package manager components are installed
# Ensures that the PACKAGE_MANAGER environment variable is set
#

if [ -z "$PACKAGE_MANAGER" ]; then
    echo 'No $PACKAGE_MANAGER found'

    if [ -e "$(which pacman)" ]; then
        echo "We're on Arch!"
        export PACKAGE_MANAGER=pacman
    elif [ -e "$(which brew)" ] || [[ "$OSTYPE" == "darwin"* ]]; then
        echo "We're on Mac!"
        export PACKAGE_MANAGER=homebrew
    else
        exit 1
    fi

else
    echo "$PACKAGE_MANAGER found"
fi

case "$PACKAGE_MANAGER" in
    "pacman")
        if [ ! -e "$(which packer)" ]; then
            echo "We need to make packer"
            # Make packer
        fi
    ;;
    "homebrew")
        if [ ! -e "$(which brew)" ]; then
            echo "We need to get homebrew"
            xcode-select --install
            ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
        fi
        if [ ! -e "$(which brew cask | head -n 1)" ]; then
            echo "We need to get cask"
            brew install caskroom/cask/brew-cask
        fi
        brew upgrade caskroom/cask/brew-cask
    ;;
    *)
        exit 1
    ;;
esac

echo 'Done! You for sure have a package manager'