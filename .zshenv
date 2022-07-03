#!/usr/bin/zsh

export \
    XDG_CONFIG_HOME="$HOME/.local/etc" \
    XDG_DATA_HOME="$HOME/.local/share" \
    XDG_CACHE_HOME="$HOME/.local/var/cache" \
    XDG_STATE_HOME="$HOME/.local/var/lib" \
    XDG_BIN_HOME="$HOME/.local/bin"

export \
    CARGO_HOME="$XDG_CACHE_HOME/cargo" \
    CARGO_TARGET_DIR="$XDG_STATE_HOME/cargo"
export \
    CONDARC="$XDG_CONFIG_HOME/.condarc" \
    CONDA_ROOT="$XDG_STATE_HOME/conda" \
    CONDA_SYSTEM="$XDG_DATA_HOME/conda/system" \
    CONDA_PKGS_DIRS="$XDG_CACHE_HOME/conda" \
    CONDA_ENVS_PATH="$CONDA_ROOT:$CONDA_SYSTEM:$XDG_DATA_HOME/conda/base" \
export \
    GOPATH="$XDG_STATE_HOME/go" \
    GOMODCACHE="$XDG_CACHE_HOME/go-mod" \
    GOBIN="$XDG_BIN_HOME"
export \
    NPM_CONFIG_CACHE="$XDG_CACHE_HOME/npm" \
    NPM_CONFIG_USERCONFIG="$XDG_CONFIG_HOME/npm/.npmrc" \
    NPM_CONFIG_INIT_MODULES="$XDG_CONFIG_HOME/npm/.npm.init.js" \
export ZDOTDIR="$XDG_CONFIG_HOME/zsh"

typeset -aU path
# Remove windows paths in wsl
path=(${path[@]:#*/mnt/c/*})
path=(
    $XDG_BIN_HOME 
    "$CARGO_HOME/bin"
    "$GOPATH/bin"
    "$CONDA_SYSTEM/installers-conda/bin"
    $path
    "/mnt/c/Users/`id -un`/scoop/shims/"
    "/mnt/c/Windows/system32")
