# shellcheck shell=bash
# vi: ft=sh

export COLORTERM="truecolor"
export INPUTRC="$XDG_CONFIG_HOME/.inputrc"
export HISTFILE="$XDG_STATE_HOME/${ZHISTFILE:-.zsh_history}"

export \
	PIPX_HOME="$XDG_STATE_HOME/pipx"

export \
	NPM_CONFIG_CACHE="$XDG_CACHE_HOME/npm" \
	NPM_CONFIG_USERCONFIG="$XDG_CONFIG_HOME/npm/.npmrc" \
	NPM_CONFIG_INIT_MODULES="$XDG_CONFIG_HOME/npm/.npm.init.js"

export \
	GOPATH="$XDG_STATE_HOME/go"
