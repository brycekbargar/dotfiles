# shellcheck shell=bash
# vi: ft=zsh

setopt no_auto_remove_slash

# shellcheck disable=SC1091
source "$XDG_PKG_HOME/.rye/shims/aws_zsh_completer.sh"
eval "$(bw completion --shell zsh 2>/dev/null)"
compdef fd-fzf=fd
compdef jq=gojq
compdef _files lss
compdef rg-fzf=rg
compdef umamba=micromamba
