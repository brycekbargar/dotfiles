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
  --lesskey-src=$HOME/_setup/dotfiles/XDG_CONFIG_HOME/.lesskey$ \
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

source "$ZDOTDIR"/zprezto/init.zsh
zstyle ':prezto:*:*' color 'yes'
zstyle ':prezto:load' pmodule \
  'environment' \
  'terminal' \
  'history' \
  'directory' \
  'completion' \
  'prompt'
zstyle ':prezto:module:editor' key-bindings 'vi'
zstyle ':prezto:module:prompt' theme 'steeef'
