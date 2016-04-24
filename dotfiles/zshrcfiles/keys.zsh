#!/bin/zsh
#
# Configures keybindings
#

# I'm cool enough to try using vi for terminal navigation though...
# http://dougblack.io/words/zsh-vi-mode.html
bindkey -v

function zle-line-init zle-keymap-select () {
    VIM_PROMPT="[NORMAL]%"
    RPS1="${${KEYMAP/vicmd/$VIM_PROMPT}/(main|viins)/} $EPS1"
    zle reset-prompt
}

zle -N zle-line-init
zle -N zle-keymap-select
export KEYTIMEOUT=1