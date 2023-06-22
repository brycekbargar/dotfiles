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

eval $(thefuck --alias)
