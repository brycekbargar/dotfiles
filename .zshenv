#!/usr/bin/zsh

export \
    XDG_CONFIG_HOME="$HOME/.local/etc" \
    XDG_DATA_HOME="$HOME/.local/share" \
    XDG_CACHE_HOME="$HOME/.local/var/cache" \
    XDG_STATE_HOME="$HOME/.local/var/lib" \
    XDG_BIN_HOME="$HOME/.local/bin"

export \
    CONDA_BASE="$XDG_DATA_HOME/conda/base" \
    CONDA_SYSTEM="$XDG_DATA_HOME/conda/system" \
    CONDA_ENVS="$XDG_STATE_HOME/conda"
export \
    CONDARC="$XDG_CONFIG_HOME/.condarc" \
    CONDA_PKGS_DIRS="$XDG_CACHE_HOME/conda" \
    CONDA_ENVS_PATH="$CONDA_ENVS:$CONDA_SYSTEM:$CONDA_BASE"
export \
    CARGO_HOME="$XDG_CACHE_HOME/cargo" \
    CARGO_TARGET_DIR="$XDG_CACHE_HOME/cargo-gen" \
    CARGO_INSTALL_ROOT="$XDG_STATE_HOME/cargo" \
    CARGO_CACHE_RUSTC_INFO=0 \
    CARGO_INCREMENTAL=1
export \
    GOPATH="$XDG_STATE_HOME/go" \
    GOMODCACHE="$XDG_CACHE_HOME/go-mod"
export ZDOTDIR="$XDG_CONFIG_HOME/zsh"

typeset -aU path
# Remove windows paths in wsl
path=(${path[@]:#*/mnt/c/*})
path=(
    $XDG_BIN_HOME 
    "$CARGO_INSTALL_ROOT/bin"
    "$GOPATH/bin"
    "$CONDA_SYSTEM/installers-conda/bin"
    $path
    "/mnt/c/Users/`id -un`/scoop/shims/"
    "/mnt/c/Windows/system32")

typeset -aU fpath
fpath=("$XDG_BIN_HOME/shims" $fpath)
autoload -Uz $XDG_BIN_HOME/shims/*(.:t)
