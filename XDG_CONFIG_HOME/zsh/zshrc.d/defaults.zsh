# shellcheck shell=bash
# vi: ft=sh

# Usually the longest one is the one we want
SHELL="$(
	type -a zsh |
		awk '{ print length, $NF }' |
		sort -n -r |
		awk 'NR==1{ print $2 }'
)"
export SHELL
export COLORTERM="truecolor"
# shellcheck disable=SC2046
eval $(dircolors)

export INPUTRC="$XDG_CONFIG_HOME/.inputrc"
export HISTFILE="$XDG_STATE_HOME/${ZHISTFILE:-.zsh_history}"

setopt no_auto_remove_slash
