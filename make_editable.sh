#!/usr/bin/env bash

ln -sf "$HOME/code/dotfiles/.zshenv" "$HOME/.zshenv"
[ -h "$ZDOTDIR/functions" ] || rm -fdr "$ZDOTDIR/functions"
ln -sf "$HOME/code/dotfiles/XDG_CONFIG_HOME/zsh/functions" "$ZDOTDIR/functions"
[ -h "$ZDOTDIR/zshc.d" ] || rm -fdr "$ZDOTDIR/zshrc.d"
ln -sf "$HOME/code/dotfiles/XDG_CONFIG_HOME/zsh/zshrc.d" "$ZDOTDIR/zshrc.d"
ln -sf "$HOME/code/dotfiles/XDG_CONFIG_HOME/zsh/myrc.zsh" "$ZDOTDIR/myrc.zsh"
ln -sf "$HOME/code/dotfiles/XDG_CONFIG_HOME/zsh/pre_antidote.zsh" "$ZDOTDIR/pre_antidote.zsh"

[ -h "$XDG_CONFIG_HOME/nvim" ] || rm -fdr "$XDG_CONFIG_HOME/nvim"
ln -sf "$HOME/code/dotfiles/XDG_CONFIG_HOME/nvim" "$XDG_CONFIG_HOME/nvim"

[ -h "$XDG_BIN_HOME/shims" ] || rm -fdr "$XDG_BIN_HOME/shims"
for item in "$HOME/code/dotfiles/XDG_BIN_HOME"/*; do
	ln -sf "$(realpath "$item")" "$XDG_BIN_HOME/$(basename "$item")"
done
