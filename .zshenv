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
  	CONDA_ENVS="/opt/conda/envs" \
  	CONDA_PKGS_DIRS="/opt/conda/pkgs" \
  	CONDA_ENVS_PATH="/opt/conda/envs:$XDG_STATE_HOME/conda" \
  	ZDOTDIR="$XDG_CONFIG_HOME/zsh" \
  	ANTIDOTE_SOURCE="$XDG_CONFIG_HOME/zsh/.antidote" \
  	ANTIDOTE_HOME="$XDG_CONFIG_HOME/zsh/.bundles"

typeset -aU path
path=(
  	"$XDG_BIN_HOME"
  	"$XDG_PKG_HOME"
  	"$XDG_BIN_HOME/shims"
  	"$XDG_PKG_HOME/.rye/shims"
  	"$XDG_PKG_HOME/.tjn/bin"
  	$path)
