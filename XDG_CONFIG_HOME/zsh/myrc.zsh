# shellcheck shell=bash
# vi: ft=zsh

if [[ -r "$XDG_CACHE_HOME/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  # shellcheck disable=SC1091
  source "$XDG_CACHE_HOME/p10k-instant-prompt-${(%):-%n}.zsh"
fi

source $ZDOTDIR/pre_antidote.zsh
source "$ANTIDOTE_SOURCE/antidote.zsh"
antidote load

# Inlining https://github.com/mattmc3/zephyr
# Load zfunctions.
export ZFUNCDIR="$ZDOTDIR/functions"
fpath=("$ZFUNCDIR" $fpath)
autoload -Uz $fpath[1]/*(.:t)

# Load zfunctions subdirs.
for _fndir in $ZFUNCDIR(N/) $ZFUNCDIR/*(N/); do
  fpath=("$_fndir" $fpath)
  autoload -Uz $fpath[1]/*(.:t)
done
unset _fndir

_confd="$ZDOTDIR/zshrc.d"
# Source all files in conf.d.
for _rcfile in $_confd[1]/*.{z,}sh(N); do
  source "$_rcfile"
done
unset _rcfile _confd
