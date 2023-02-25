#!/usr/bin/env bash
echo "go make some tea"

# shellcheck disable=SC1090
which conda >/dev/null || source <("$CONDA_SYSTEM/base/bin/conda" shell.zsh hook)
ANSIBLE_CONFIG="$(pwd)/playbooks/ansible.cfg" \
	conda run --name dotfiles --no-capture-output \
	ansible-playbook "playbooks/default.playbook.yml"
