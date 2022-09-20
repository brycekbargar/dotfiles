# Usually the longest one is the one we want
export EDITOR="$(
	type -a vim |
		awk '{ print length, $NF }' |
		sort -n -r |
		awk 'NR==1{ print $2 }'
)"

export SUDO_EDIT="$EDITOR"
export VISUAL="$EDITOR"
