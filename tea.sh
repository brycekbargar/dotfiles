#!/usr/bin/env bash
echo "go make some tea"

# shellcheck disable=SC1090
which conda >/dev/null || source <("$CONDA_BASE/bin/conda" shell.zsh hook)
if ! conda env list | grep dotfiles -q; then
	CONDA_ENVS_PATH="$CONDA_SYSTEM" conda create --name dotfiles --file conda-linux-64.lock --quiet --yes
fi

ANSIBLE_CONFIG="$(pwd)/playbooks/ansible.cfg" \
	conda run --name dotfiles --no-capture-output \
	ansible-playbook "playbooks/default.playbook.yml"
