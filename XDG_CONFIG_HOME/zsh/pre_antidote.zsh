# shellcheck shell=bash
# vi: ft=zsh

zstyle ':antidote:bundle' use-friendly-names 'yes'
zstyle ':zsh-utils:plugins:completion' use-xdg-basedirs 'yes'
eval "$(umamba shell hook -s zsh)"
