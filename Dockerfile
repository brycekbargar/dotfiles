# syntax=docker/dockerfile:1

# Environment specific args
ARG USER=bryce
ARG DOCKER_GROUP=1001
ARG HOSTOS=windows

# Shortcuts shared across multiple stages
ARG HOME="/home/${USER}"
ARG PKG_HOME="${HOME}/.local/opt"

FROM registry.hub.docker.com/library/debian:testing-slim AS upstream-debian
FROM upstream-debian AS debian
RUN <<APT
set -eu
apt-get update
apt-get install --no-install-recommends --yes \
	build-essential \
	ca-certificates \
	curl \
	git \
	git-lfs \
	less \
	libncursesw6 \
	lowdown \
	openssh-client \
	shellcheck \
	sudo \
	unzip \
	vim \
	vim-doc \
	zsh
rm -rf /var/lib/apt/lists/*
APT

# Install tools written in javascript
FROM debian AS tools-js
ARG PKG_HOME
ENV N_PREFIX="${PKG_HOME}/.tjn"
ENV N_CACHE_PREFIX="/tmp"
ADD https://raw.githubusercontent.com/tj/n/master/bin/n /usr/bin/n
RUN chmod +x /usr/bin/n
RUN <<TJN
set -eu
n latest
export PATH=$N_PREFIX/bin:$PATH
npm install -g npm@latest
# bw cli is pinned to 2023.7.0 because of
# https://github.com/bitwarden/clients/pull/8073
npm install -g \
	@ansible/ansible-language-server \
	bash-language-server \
	@bitwarden/cli@2023.7.0 \
	dockerfile-language-server-nodejs \
	fixjson \
	pyright \
	tiged \
	vscode-langservers-extracted \
	yaml-language-server

rm $N_PREFIX/bin/npm
TJN

# Build out the base of the final image
FROM debian AS dev-container
ARG USER
ARG DOCKER_GROUP
# bash is necessary here for the install command
# install makes it easy to create/mod/own the files in a single command
RUN <<NONROOT
#! /usr/bin/env bash
set -euo pipefail
groupadd --gid ${DOCKER_GROUP} docker
groupadd --gid 1111 "${USER}"
useradd --no-log-init --shell /usr/bin/zsh --create-home \
	--uid 1111 --gid 1111 "${USER}"
passwd --delete "${USER}"
usermod --append --groups sudo,docker "${USER}"
install --mode 0440 -D <(echo "$USER ALL=(ALL) NOPASSWD: ALL") "/etc/sudoers.d/1111"
# These should be mounted as volumes at runtime but don't fail if they're missing
install --owner 1111 --group 1111 -D --directory /opt/pixi/envs /opt/pixi/pkgs
NONROOT

FROM dev-container AS ansible
ARG HOME
ARG SETUP=${HOME}/_setup
ARG PKG_HOME

COPY --from=ghcr.io/prefix-dev/pixi:bullseye /usr/local/bin/pixi /usr/local/bin/pixi
COPY --chown=1111:1111 ./dotfiles ${SETUP}/dotfiles
COPY --chown=1111:1111 ./private ${SETUP}/private

ARG HOSTOS
# The Ansible playbook uses this
ENV HOSTOS=${HOSTOS}
WORKDIR ${SETUP}/dotfiles
USER 1111:1111
RUN --mount=type=cache,target=${HOME}/.local/var  <<ANSIBLE
#! /usr/bin/zsh
set -euo pipefail
sudo chown 1111:1111 ${HOME}/.local/var
source "${SETUP}/dotfiles/.zshenv"
pixi global install python ansible jmespath
ANSIBLE_CONFIG="$(pwd)/playbooks/ansible.cfg" \
	ansible-playbook "playbooks/default.playbook.yml"
# TODO: Figure out how to do this in the playbook
set +eu
source "$ZDOTDIR/myrc.zsh"
ANSIBLE

# This is for any final IO operations needed before squashing the final image into a single layer
FROM dev-container AS home-layer
ARG HOME
ARG PKG_HOME
# RUN instead of COPY to preserve symlinks
RUN --mount=type=bind,from=ansible,source=${HOME},target=${HOME} \
	cp --no-dereference --recursive --target . ./_setup ./local ./.vim ./.zshenv
COPY --from=registry.hub.docker.com/library/docker:cli /usr/local/bin/docker ${XDG_PKG_HOME}/docker
COPY --from=registry.hub.docker.com/docker/buildx-bin /buildx ${HOME}/.docker/cli-plugins/docker-buildx
COPY --from=registry.hub.docker.com/docker/compose-bin /docker-compose ${HOME}/.docker/cli-plugins/docker-compose
COPY --from=ghcr.io/prefix-dev/pixi:bullseye /usr/local/bin/pixi ${PKG_HOME}/pixi
COPY --from=tools-js ${PKG_HOME}/.tjn ${PKG_HOME}/.tjn

FROM dev-container
ARG HOME
COPY --chown=1111:1111 --from=home-layer ${HOME} ${HOME}
WORKDIR ${HOME}/code
# XDG_STATE_HOME, XDG_CACHE_HOME, and /tmp should have most of the container writes
# Having them set to be an anon volume keeps the container size down at runtime
VOLUME ${HOME}/.local/var
VOLUME /tmp

# nvim requires this to be set to copy to osc52
ENV SSH_TTY=/dev/tty

ENTRYPOINT ["/usr/bin/zsh", "-i"]
