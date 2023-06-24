# shellcheck shell=bash
# shellcheck disable=SC1091
# vi: ft=zsh

setopt no_auto_remove_slash
fast-theme base16

source "$XDG_PKG_HOME/.rye/shims/aws_zsh_completer.sh"
eval "$(bw completion --shell zsh)"
compdef fd-fzf=fd
compdef jq=gojq
compdef _files lss
compdef rg-fzf=rg
compdef umamba=micromamba
