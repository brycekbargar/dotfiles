# shellcheck shell=bash
# vi: ft=sh

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
