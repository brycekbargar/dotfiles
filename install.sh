#!/bin/bash
#
# Run to setup dotfiles
#
source init

requires ssh-host-key
requires ssh-identity-keys

requires lastpass-installed
requires zsh-installed

requires environment-specific-packages
