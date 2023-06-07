# shellcheck shell=bash
# vi: ft=zsh

if [[ -r "$XDG_CACHE_HOME/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  # shellcheck disable=SC1091
  source "$XDG_CACHE_HOME/p10k-instant-prompt-${(%):-%n}.zsh"
fi

source $ZDOTDIR/pre_antidote.zsh
source "$ANTIDOTE_SOURCE/antidote.zsh"
antidote load
