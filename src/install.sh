#!/bin/bash

local repoDir="$(pwd)"
local srcDir="$repoDir/src"

source "$repoDir/utils/logging"

log_step "01 Set Environment"
source "$repoDir/utils/set-environment"

log_step "02 Setup Package Manager"
source "$repoDir/$ENVIRONMENT/02_setup-package-manager"

log_step "03 Sync SSH Keys"
source "$repoDir/$ENVIRONMENT/03_sync-ssh-keys"

log_step "04 Install git"
source "$repoDir/$ENVIRONMENT/04_install-git"

log_step "05 Install zsh"
source "$repoDir/$ENVIRONMENT/05_install-zsh"

log_step "06 Install tmux"
source "$repoDir/$ENVIRONMENT/06_install-tmux"

log_step "07 Install neovim"
source "$repoDir/$ENVIRONMENT/07_install-neovim"

log_step "08 Install Environment Specific Packages"
source "$repoDir/$ENVIRONMENT/08_packages"

exit 0
