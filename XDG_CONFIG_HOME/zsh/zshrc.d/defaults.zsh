setopt no_auto_remove_slash
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'

export COLORTERM="truecolor"
eval $(dircolors)

export INPUTRC="$XDG_CONFIG_HOME/.inputrc"
