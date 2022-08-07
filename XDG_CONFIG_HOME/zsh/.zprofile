export \
    INPUTRC="$XDG_CONFIG_HOME/.inputrc"
export \
    NPM_CONFIG_CACHE="$XDG_CACHE_HOME/npm" \
    NPM_CONFIG_USERCONFIG="$XDG_CONFIG_HOME/npm/.npmrc" \
    NPM_CONFIG_INIT_MODULES="$XDG_CONFIG_HOME/npm/.npm.init.js" \
export \
    PIPX_HOME="$XDG_STATE_HOME/pipx"
export \
    BITWARDENCLI_APPDATA_DIR="$XDG_STATE_HOME/bw"
export \
    RIPGREP_CONFIG_PATH="$XDG_CONFIG_HOME/ripgrep"

export COLORTERM="truecolor"
export PAGER='/usr/bin/less'
export LESS='--ignore-case --raw-control-chars -FRXK'
export EDITOR='vim'
export SUDO_EDIT="$EDITOR"
export VISUAL="$EDITOR"
