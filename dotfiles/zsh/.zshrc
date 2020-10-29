#!/bin/zsh

source "$HOME/.zshrcfiles/local-pre-antibody.zsh"

source <(antibody init)
antibody bundle brycekbargar/dotfiles path:dotfiles/zsh/zshrcfiles
antibody bundle < "$HOME/.zshrcfiles/.antibody_plugins"

source "$HOME/.zshrcfiles/local-post-antibody.zsh"

cd $HOME/_src