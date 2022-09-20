# shellcheck shell=bash
# vi: ft=zsh

if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  # shellcheck disable=SC1091
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

source $ZDOTDIR/pre_antidote.zsh

if [[ ! $XDG_STATE_HOME/.zsh_plugins.zsh -nt $ZDOTDIR/.zsh_plugins.txt ]]; then
    source $XDG_BIN_HOME/antidote/antidote.zsh
    antidote bundle <$ZDOTDIR/.zsh_plugins.txt >$XDG_STATE_HOME/.zsh_plugins.zsh
fi
autoload -Uz "$XDG_BIN_HOME/antidote/functions/antidote"
antidote update > /dev/null
source $XDG_STATE_HOME/.zsh_plugins.zsh
