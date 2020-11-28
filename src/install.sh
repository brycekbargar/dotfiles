#!/bin/bash

# Jump to and resolve the full path to relevant folders
pushd "$(dirname $0)"
  SRC="$(pwd)"
  pushd '../'
    DOTFILES="$(pwd)/dotfiles/"
  popd
popd

# TODO: Replace this with something less hand-rolled
source "$SRC/logging"

source "$SRC/setup-package-manager"

source "$SRC/install-zsh"
source "$SRC/install-antibody"

source "$SRC/install-bitwarden"
source "$SRC/setup-ssh"

source "$SRC/setup-git"
source "$SRC/install-vim"

source "$SRC/install-golang"

exit 0
