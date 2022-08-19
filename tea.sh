#!/usr/bin/env bash
echo "go make some tea"

if [ "$(uname -s)" = "Linux" ]
then
	conda run --name dotfiles --no-capture-output \
		ansible-playbook playbooks/home.playbook.yml \
		--ask-become-pass
else
	conda run --name dotfiles --no-capture-output \
		ansible-playbook playbooks/work.playbook.yml
fi
