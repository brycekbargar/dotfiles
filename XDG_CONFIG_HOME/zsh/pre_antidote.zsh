# shellcheck shell=bash
# vi: ft=zsh

zstyle ':antidote:bundle' use-friendly-names 'yes'

# dircolors needs the shell variable
# Usually the longest one is the one we want
SHELL="$(
	type -a zsh |
		awk '{ print length, $NF }' |
		sort -n -r |
		awk 'NR==1{ print $2 }'
)"
export SHELL
# We're setting dircolors here because prezto completions wants LS_COLORS
# shellcheck disable=SC2046
eval $(dircolors)
