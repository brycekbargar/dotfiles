#!/bin/zsh
#
# History settings
#

HISTFILE=${HISTFILE:-"$HOME"/.zsh_history}
HISTSIZE=1000
SAVEHIST=1000

setopt APPEND_HISTORY

setopt HIST_ALLOW_CLOBBER
setopt HIST_REDUCE_BLANKS

setopt HIST_IGNORE_ALL_DUPS
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_SAVE_NO_DUPS
setopt HIST_FIND_NO_DUPS