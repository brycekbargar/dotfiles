#!/usr/bin/env bash
echo "go make some tea"

playbook="playbooks/home.playbook.yml"
[ "$(id -un)" = "user" ] && playbook="playbooks/work.playbook.yml"

ANSIBLE_CONFIG="$(pwd)/playbooks/ansible.cfg" \
conda run --name dotfiles --no-capture-output \
	ansible-playbook "$playbook" \
	--ask-become-pass
