# shellcheck shell=bash
# vi: ft=zsh

compstyle_zshzoo_setup
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'

compdef _rg rg rg-fzf
compdef _fd rg fd-fzf
compdef _gojq gojq jq
compdef _exa exa

# shellcheck disable=SC1091
source "$RYE_HOME/shims/aws_zsh_completer.sh"
