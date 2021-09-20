#!/bin.zsh

typeset -U path
path=(/usr/local/bin /usr/local/sbin $path)

# Remove windows paths
path=(${path[@]:#*/mnt/c/Users/`whoami`*})
path=(${path[@]:#*/mnt/c/Windows})
path=(${path[@]:#*/mnt/c/Windows/System32/*})
path=(${path[@]:#*/mnt/c/Program Files/*})