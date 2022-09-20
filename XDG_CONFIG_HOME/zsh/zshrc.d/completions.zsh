# shellcheck shell=bash
# vi: ft=zsh

compstyle_zshzoo_setup

compdef _rg rg rg-fzf
compdef _fd rg fd-fzf
compdef _gojq gojq jq
compdef _exa exa

# shellcheck disable=SC1091
source "$XDG_CACHE_HOME/antidote/aws/aws-cli/bin/aws_zsh_completer.sh"
