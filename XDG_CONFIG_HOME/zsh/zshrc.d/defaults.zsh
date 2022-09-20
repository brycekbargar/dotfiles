# shellcheck shell=bash
# vi: ft=sh

setopt no_auto_remove_slash
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'

export COLORTERM="truecolor"
# shellcheck disable=SC2046
eval $(dircolors)

export INPUTRC="$XDG_CONFIG_HOME/.inputrc"
