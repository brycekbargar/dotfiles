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
export \
    NPM_CONFIG_CACHE="$XDG_CACHE_HOME/npm" \
    NPM_CONFIG_USERCONFIG="$XDG_CONFIG_HOME/npm/.npmrc" \
    NPM_CONFIG_INIT_MODULES="$XDG_CONFIG_HOME/npm/.npm.init.js" \
export \
    RYE_HOME="$XDG_PKG_HOME/.rye" \
    PIPX_HOME="$XDG_STATE_HOME/pipx"
export \
    NVIM_BIN="$HOME/.nvim"

typeset -aU path
path=(
    "$XDG_BIN_HOME"
    "$XDG_PKG_HOME"
    "$RYE_HOME/shims"
    "$XDG_BIN_HOME/shims"
    "$NVIM_BIN"
    $path)
