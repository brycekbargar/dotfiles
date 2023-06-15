# shellcheck shell=bash
# vi: ft=sh

export RIPGREP_CONFIG_PATH="$XDG_CONFIG_HOME/ripgrep/config"

export FZF_DEFAULT_OPTS="\
--no-mouse --cycle --scroll-off=3
--exit-0 \
--color=16"

export BITWARDENCLI_APPDATA_DIR="$XDG_STATE_HOME/bw"

export \
	AWS_CLI_HISTORY_FILE="$XDG_STATE_HOME/aws/history" \
	AWS_CONFIG_FILE="$XDG_CONFIG_HOME/aws/config" \
	AWS_SHARED_CREDENTIALS_FILE="$XDG_CONFIG_HOME/aws/credentials"

export \
    PIPX_HOME="$XDG_STATE_HOME/pipx"

export \
    NPM_CONFIG_CACHE="$XDG_CACHE_HOME/npm" \
    NPM_CONFIG_USERCONFIG="$XDG_CONFIG_HOME/npm/.npmrc" \
    NPM_CONFIG_INIT_MODULES="$XDG_CONFIG_HOME/npm/.npm.init.js" \

eval $(thefuck --alias)
