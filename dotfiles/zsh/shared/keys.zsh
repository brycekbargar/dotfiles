bindkey -v
setopt transient_rprompt

function zle-line-init zle-keymap-select {
    VIM_PROMPT="%B%F{174}% [% NORMAL]% %f%b"
    RPS1="${${KEYMAP/vicmd/$VIM_PROMPT}/(main|viins)/}"
    zle reset-prompt
}

zle -N zle-line-init
zle -N zle-keymap-select
export KEYTIMEOUT=1
