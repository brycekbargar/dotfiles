# syntax=docker/dockerfile:1

# Environment specific args
ARG USER=bryce
ARG DOCKER_GROUP=1001
ARG HOSTOS=windows

# Shortcuts shared across multiple stages
ARG HOME="/home/${USER}"

FROM registry.hub.docker.com/library/debian:sid-slim AS upstream-debian
FROM ghcr.io/prefix-dev/pixi:trixie AS upstream-pixi
FROM registry.hub.docker.com/library/docker:cli AS upstream-docker
FROM registry.hub.docker.com/docker/buildx-bin AS upstream-buildx
FROM registry.hub.docker.com/docker/compose-bin AS upstream-compose

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
	procps \
	sudo \
	unzip \
	vim \
	vim-doc \
	zsh
rm -rf /var/lib/apt/lists/*
APT


# Build out the base of the final image
FROM debian AS dev-container
ARG HOME
ARG USER
ARG DOCKER_GROUP
# bash is necessary here for the install command
# install makes it easy to create/mod/own the files in a single command
RUN <<NONROOT
#! /usr/bin/env bash
set -euo pipefail
groupadd --gid "${DOCKER_GROUP}" docker
groupadd --gid 1111 "${USER}"
useradd --no-log-init --shell /usr/bin/zsh --create-home \
	--uid 1111 --gid 1111 "${USER}"
passwd --delete "${USER}"
usermod --append --groups sudo,docker "${USER}"
install --mode 0440 -D <(echo "$USER ALL=(ALL) NOPASSWD: ALL") "/etc/sudoers.d/1111"
install --owner 1111 --group 1111 -D --directory "${HOME}"/.local/
# These should be mounted as volumes at runtime but don't fail if they're missing
install --owner 1111 --group 1111 -D --directory /opt/pixi/envs /opt/pixi/pkgs
NONROOT

# Install non-packaged tools and setup configurations
FROM dev-container AS ansible
ARG HOME

COPY --from=upstream-pixi /usr/local/bin/pixi /usr/local/bin/pixi
COPY --chown=1111:1111 ./ "${HOME}/dotfiles"

ARG HOSTOS
# The Ansible playbook uses this
ENV HOSTOS="${HOSTOS}"
WORKDIR "${HOME}/dotfiles"
USER 1111:1111
RUN --mount=type=cache,target=${HOME}/.local/var <<ANSIBLE
#! /usr/bin/zsh
set -euo pipefail

sudo chown -R 1111:1111 "${HOME}/.local/var"
source "${HOME}/dotfiles/.zshenv"

mkdir -p "$PIXI_HOME"
pixi global install --environment dotfiles 'ansible-core<2.19' --with python --with ansible --with jmespath
ANSIBLE_CONFIG="$(pwd)/playbooks/ansible.cfg" ANSIBLE_HOME="${HOME}/.local/var/cache/ansible" \
	ansible-playbook "playbooks/default.playbook.yml"
ANSIBLE

# This is for any final IO operations needed before squashing the final image into a single layer
FROM dev-container AS home-layer
ARG HOME

COPY .zshenv "${HOME}/.zshenv"
COPY --from=ansible "${HOME}/.local/opt" "${HOME}/.local/opt"
COPY --from=ansible "${HOME}/.local/etc" "${HOME}/.local/etc"
COPY --from=ansible "${HOME}/.local/bin" "${HOME}/.local/bin"
COPY --from=ansible "${HOME}/.vim" "${HOME}/.vim"

COPY --from=upstream-pixi /usr/local/bin/pixi "${HOME}/.local/opt/pixi"
COPY ./pixi-global.toml "${HOME}/.local/var/lib/pixi/manifests/pixi-global.toml"

COPY --from=upstream-docker /usr/local/bin/docker "${HOME}/.local/opt/docker"
COPY --from=upstream-buildx /buildx "${HOME}/.docker/cli-plugins/docker-buildx"
COPY --from=upstream-compose /docker-compose "${HOME}/.docker/cli-plugins/docker-compose"

FROM dev-container
ARG HOME

COPY --chown=1111:1111 --from=home-layer "${HOME}" "${HOME}"
WORKDIR "${HOME}/code"
# XDG_STATE_HOME, XDG_CACHE_HOME, and /tmp should have most of the container writes
# Having them set to be an anon volume keeps the container size down at runtime
VOLUME "${HOME}/.local/var"
VOLUME /tmp

ENTRYPOINT ["/usr/bin/zsh", "-i"]
