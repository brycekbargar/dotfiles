# Usually the longest one is the one we want
EDITOR="$(
	type -a vim |
		awk '{ print length, $NF }' |
		sort -n -r |
		awk 'NR==1{ print $2 }'
)"
export EDITOR

export SUDO_EDIT="$EDITOR"
export VISUAL="$EDITOR"
