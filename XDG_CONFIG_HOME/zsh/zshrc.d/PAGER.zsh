# shellcheck shell=bash
# vi: ft=sh

# Usually the longest one is the one we want
PAGER="$(
	type -a less |
		awk '{ print length, $NF }' |
		sort -n -r |
		awk 'NR==1{ print $2 }'
)"
export PAGER

export LESS=" \
  --quit-if-one-screen \
  --ignore-case \
  --lesskey-src=$XDG_CONFIG_HOME/.lesskey$ \
  --SILENT \
  --RAW-CONTROL-CHARS \
  --squeeze-blank-lines \
  --HILITE-UNREAD \
  --tabs=4 \
  --tilde \
  --incsearch \
  --use-color"
export LESSHISTFILE="$XDG_STATE_HOME/less/history"
