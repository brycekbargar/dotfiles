#!/usr/bin/env bash
echo "go make some tea"

# shellcheck disable=SC1090
which conda >/dev/null || source <(~/.local/share/conda/base/bin/conda shell.zsh hook)
conda env list | grep dotfiles -q || conda env create --file environment.yml --quiet

ANSIBLE_CONFIG="$(pwd)/playbooks/ansible.cfg" \
	conda run --name dotfiles --no-capture-output \
	ansible-playbook "playbooks/default.playbook.yml"
