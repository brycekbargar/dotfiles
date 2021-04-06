#!/bin.zsh

typeset -U path
path=(/usr/local/bin /usr/local/sbin $path)

# Remove windows paths
path=(${path[@]:#*/mnt/c/Users/`whoami`*})
path=(${path[@]:#*/mnt/c/WINDOWS/System32/OpenSSH/*})
path=(${path[@]:#*/mnt/c/Program Files/Microsoft SQL Server/*})
path=(${path[@]:#*/mnt/c/Program Files/dotnet*})
