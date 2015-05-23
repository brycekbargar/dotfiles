#!/bin/bash
#
# Run to setup dotfiles
# Right now it just acts as a shell container so I can test exits
#
source init

requires homebrew-github-api-token

# Do some fancy stuff with ssh keys
requires ssh-host-key
requires ssh-identity-keys

# Do some fancy stuff with symlinking configs