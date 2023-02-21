#!/usr/bin/zsh

export \
    XDG_CONFIG_HOME="$HOME/.local/etc" \
    XDG_DATA_HOME="$HOME/.local/share" \
    XDG_CACHE_HOME="$HOME/.local/var/cache" \
    XDG_STATE_HOME="$HOME/.local/var/lib" \
    XDG_BIN_HOME="$HOME/.local/bin" \
    XDG_PKG_HOME="$HOME/.local/opt"

export \
    CONDARC="$XDG_CONFIG_HOME/conda/condarc" \
    CONDA_SYSTEM="$XDG_STATE_HOME/conda" \
    CONDA_ENVS="/conda/envs" \
    CONDA_PKGS_DIRS="conda/pkgs"
export \
    CONDA_BASE="$CONDA_SYSTEM/base" \
    CONDA_ENVS_PATH="$CONDA_ENVS:$CONDA_SYSTEM"
export \
    CARGO_HOME="$XDG_CACHE_HOME/cargo" \
    CARGO_TARGET_DIR="$XDG_CACHE_HOME/cargo" \
    CARGO_INSTALL_ROOT="$XDG_STATE_HOME/cargo" \
    CARGO_CACHE_RUSTC_INFO=0 \
    CARGO_INCREMENTAL=1
export \
    GOPATH="$XDG_STATE_HOME/go" \
    GOMODCACHE="$XDG_CACHE_HOME/go-mod"
export \
    ZDOTDIR="$XDG_CONFIG_HOME/zsh"
export \
    NPM_CONFIG_CACHE="$XDG_CACHE_HOME/npm" \
    NPM_CONFIG_USERCONFIG="$XDG_CONFIG_HOME/npm/.npmrc" \
    NPM_CONFIG_INIT_MODULES="$XDG_CONFIG_HOME/npm/.npm.init.js" \
export \
    PIPX_HOME="$XDG_STATE_HOME/pipx"

typeset -aU path
# Remove windows paths in wsl
path=(${path[@]:#*/mnt/c/*})
path=(
    "$XDG_BIN_HOME/shims"
    "$XDG_BIN_HOME"
    "$XDG_PKG_HOME/rust"
    "$XDG_PKG_HOME/go"
    "$XDG_PKG_HOME/ports"
    "$XDG_PKG_HOME/gports"
    "$CONDA_BASE/condabin"
    $path
    "/mnt/c/Users/`id -un`/scoop/shims/"
    "/mnt/c/Windows/system32")
