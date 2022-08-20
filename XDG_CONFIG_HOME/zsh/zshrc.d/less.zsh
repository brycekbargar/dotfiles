if [ "$(uname -s)" = "Linux" ]
then
	export PAGER='/usr/bin/less'
else
	export PAGER="$XDG_PKG_HOME/homebrew/less"
fi
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
