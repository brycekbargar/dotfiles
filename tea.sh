#!/usr/bin/env bash
echo "go make some tea"

mkdir -p \
	"$XDG_DATA_HOME" \
	"$XDG_CACHE_HOME" \
	"$XDG_STATE_HOME" \
	"$XDG_PKG_HOME"

# shellcheck disable=SC1090
which conda >/dev/null || source <("$CONDA_BASE/bin/conda" shell.zsh hook)
ANSIBLE_CONFIG="$(pwd)/playbooks/ansible.cfg" \
	conda run --name dotfiles --no-capture-output \
	ansible-playbook "playbooks/default.playbook.yml"
