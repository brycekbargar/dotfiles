#!/bin/zsh

source <(antibody init)
antibody bundle < "$HOME/.zshrcfiles/.antibody_plugins"

source "$HOME/.zshrcfiles/local.zsh"
