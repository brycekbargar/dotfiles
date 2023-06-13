#!/usr/bin/zsh

export \
    XDG_CACHE_HOME="$HOME/.local/var/cache" \
    XDG_STATE_HOME="$HOME/.local/var/lib" \
    XDG_CONFIG_HOME="$HOME/.local/etc" \
    XDG_BIN_HOME="$HOME/.local/bin" \
    XDG_PKG_HOME="$HOME/.local/opt" \
    XDG_DATA_HOME="$HOME/code"

export \
    CONDARC="$XDG_CONFIG_HOME/conda/condarc" \
    CONDA_SYSTEM="$XDG_STATE_HOME/conda" \
    CONDA_ENVS="/conda/envs" \
    CONDA_PKGS_DIRS="/conda/pkgs"
export \
    CONDA_ENVS_PATH="$CONDA_ENVS:$CONDA_SYSTEM"
export \
    ZDOTDIR="$XDG_CONFIG_HOME/zsh"
export \
    ANTIDOTE_SOURCE="$ZDOTDIR/.antidote" \
    ANTIDOTE_HOME="$ZDOTDIR/.bundles"

typeset -aU path
path=(
    "$XDG_BIN_HOME"
    "$XDG_PKG_HOME"
    "$XDG_BIN_HOME/shims"
    "$XDG_PKG_HOME/.rye/shims"
    $path)
