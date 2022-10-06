# shellcheck shell=bash
# vi: ft=sh

export RIPGREP_CONFIG_PATH="$XDG_CONFIG_HOME/ripgrep/config"

export FZF_DEFAULT_OPTS="\
--no-mouse --cycle --scroll-off=3
--exit-0 \
--color=16"

export \
	KITTY_CONFIG_DIRECTORY="$XDG_CONFIG_HOME/kitty" \
	KITTY_CACHE_DIRECTORY="$XDG_CACHE_HOME/kitty"

export BITWARDENCLI_APPDATA_DIR="$XDG_STATE_HOME/bw"

export \
	AWS_CLI_HISTORY_FILE="$XDG_STATE_HOME/aws/history" \
	AWS_CONFIG_FILE="$XDG_DATA_HOME/aws/config" \
	AWS_CREDENTIALS_FILE="$XDG_DATA_HOME/aws/credentials"
