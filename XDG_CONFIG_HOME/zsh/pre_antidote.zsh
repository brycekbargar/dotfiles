# shellcheck shell=bash
# vi: ft=zsh

zstyle ':antidote:bundle' use-friendly-names 'yes'
# why does this have to run before?
eval "$(umamba shell hook -s zsh --autocomplete)"
# shellcheck disable=SC2046
eval $(dircolors)
