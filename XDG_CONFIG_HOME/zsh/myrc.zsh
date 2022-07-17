if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

if [[ ! $XDG_STATE_HOME/.zsh_plugins.zsh -nt $ZDOTDIR/.zsh_plugins.txt ]]; then
    zstyle ':antidote:bundle' use-friendly-names 'yes'
    source $XDG_BIN_HOME/antidote/antidote.zsh
    antidote bundle <$ZDOTDIR/.zsh_plugins.txt >$XDG_STATE_HOME/.zsh_plugins.zsh
fi
autoload -Uz "$XDG_BIN_HOME/antidote/functions/antidote"
antidote update > /dev/null
source $XDG_STATE_HOME/.zsh_plugins.zsh