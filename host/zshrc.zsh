# shellcheck shell=bash
# vi: ft=sh

# https://github.com/sorin-ionescu/prezto/blob/master/runcoms/zlogin
# Execute code that does not affect the current session in the background.
{
  # Compile the completion dump to increase startup speed.
  zcompdump="${XDG_CACHE_HOME:-$HOME/.cache}/prezto/zcompdump"
  if [[ -s "$zcompdump" && (! -s "${zcompdump}.zwc" || "$zcompdump" -nt "${zcompdump}.zwc") ]]; then
    if command mkdir "${zcompdump}.zwc.lock" 2>/dev/null; then
      zcompile "$zcompdump"
      command rmdir  "${zcompdump}.zwc.lock" 2>/dev/null
    fi
  fi
} &!
# Set the Less input preprocessor.
# Try both `lesspipe` and `lesspipe.sh` as either might exist on a system.
if [[ -z "$LESSOPEN" ]] && (( $#commands[(i)lesspipe(|.sh)] )); then
  export LESSOPEN="| /usr/bin/env $commands[(i)lesspipe(|.sh)] %s 2>&-"
fi

export BROWSER='open'
export EDITOR="$HOMEBREW_PREFIX"/bin/vim
export VISUAL="$EDITOR"
export PAGER="$HOMEBREW_PREFIX"/bin/less
export LESS=" \
  --quit-if-one-screen \
  --ignore-case \
  --SILENT \
  --RAW-CONTROL-CHARS \
  --squeeze-blank-lines \
  --HILITE-UNREAD \
  --tabs=4 \
  --tilde \
  --incsearch \
  --use-color"

alias ls="ls -lhA"
tabs -4 > /dev/null

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

source "$ZDOTDIR"/zprezto/init.zsh
