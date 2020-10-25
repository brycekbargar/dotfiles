#!/bin/zsh

source <(antibody init)
antibody bundle < ~/.antibody_plugins

source "$HOME/.zshrcfiles/local.zsh"
