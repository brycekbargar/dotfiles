#!/bin/bash
#
# Run to setup dotfiles
# Right now it just acts as a shell container so I can test exits
#
source init

requires ssh-host-key
requires ssh-identity-keys

requires lastpass-installed
requires zsh-installed

requires environment-specific-packages
