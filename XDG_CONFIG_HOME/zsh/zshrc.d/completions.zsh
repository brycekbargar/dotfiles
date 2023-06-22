# shellcheck shell=bash
# vi: ft=zsh

setopt no_auto_remove_slash
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'

eval "$(bw completion --shell zsh)"

compdef _bw bw
compdef _conda conda
compdef _exa exa
compdef _fd rg fd-fzf
compdef _gojq gojq jq
compdef _micromamba umamba
compdef _rg rg rg-fzf

# shellcheck disable=SC1091
source "$XDG_PKG_HOME/.rye/shims/aws_zsh_completer.sh"
