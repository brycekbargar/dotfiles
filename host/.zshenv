#!/usr/bin/zsh
# shellcheck shell=bash
# vi: ft=zsh

export ZDOTDIR="$HOME/.zdotdir"

eval "$(/opt/homebrew/bin/brew shellenv zsh)"
typeset -aU path
path=(
  	"$HOME/_setup/dotfiles/host/bin"
  	$path)
