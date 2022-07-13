#!/usr/bin/env bash
echo "go make some tea"
# TODO: Parameterize for different envs
conda run --name dotfiles --no-capture-output \
	ansible-playbook playbooks/home.playbook.yml \
	--ask-become-pass
