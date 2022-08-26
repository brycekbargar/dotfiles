# Usually the longest one is the one we want
export PAGER="$(\
	type -a less \
	| awk '{ print length, $NF }' \
	| sort -n -r \
	| awk 'NR==1{ print $2 }'\
)"

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
