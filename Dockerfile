# syntax=docker/dockerfile:1

# Environment specific args
ARG USER=bryce
ARG DOCKER_GROUP=1001
ARG HOSTOS=windows

# Shortcuts shared across multiple stages
ARG HOME="/home/${USER}"
ARG PKG_HOME="${HOME}/.local/opt"
ARG PIXI_HOME=${HOME}/.local/var/lib/pixi

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
groupadd --gid ${DOCKER_GROUP} docker
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

FROM ghcr.io/prefix-dev/pixi:bullseye AS tools-pixi
ARG HOME
ARG PIXI_HOME
ENV PIXI_HOME=${PIXI_HOME}
COPY ./dotfiles-pixi-rewrite/XDG_CONFIG_HOME/pixi/manifests/pixi-global.toml ${PIXI_HOME}/manifests/pixi-global.toml
RUN /usr/local/bin/pixi global sync

FROM dev-container AS ansible
ARG HOME
ARG SETUP=${HOME}/_setup
ARG PKG_HOME

COPY --from=tools-pixi /usr/local/bin/pixi /usr/local/bin/pixi
COPY --chown=1111:1111 ./dotfiles-pixi-rewrite ${SETUP}/dotfiles
COPY --chown=1111:1111 ./private ${SETUP}/private

ARG HOSTOS
# The Ansible playbook uses this
ENV HOSTOS=${HOSTOS}
WORKDIR ${SETUP}/dotfiles
USER 1111:1111
RUN --mount=type=cache,target=${HOME}/.local/var/cache  <<ANSIBLE
#! /usr/bin/zsh
set -euo pipefail

sudo chown -R 1111:1111 ${HOME}/.local/var
source "${SETUP}/dotfiles/.zshenv"

mkdir -p "$PIXI_HOME"
pixi global install --environment dotfiles ansible-core --with python --with ansible --with jmespath
ANSIBLE_CONFIG="$(pwd)/playbooks/ansible.cfg" ANSIBLE_HOME="${HOME}/.local/var/cache/ansible" \
	ansible-playbook "playbooks/default.playbook.yml"
rm -fdr "$PIXI_HOME"

# TODO: Figure out how to do this in the playbook
set +eu
source "$ZDOTDIR/myrc.zsh"
ANSIBLE

# This is for any final IO operations needed before squashing the final image into a single layer
FROM dev-container AS home-layer
ARG HOME
ARG PKG_HOME
ARG PIXI_HOME
COPY --from=ansible ${HOME} ${HOME}
RUN rm -fdr "${HOME}/.local/var/cache" && mkdir "${HOME}/.local/var/cache"
COPY --from=registry.hub.docker.com/library/docker:cli /usr/local/bin/docker ${PKG_HOME}/docker
COPY --from=registry.hub.docker.com/docker/buildx-bin /buildx ${HOME}/.docker/cli-plugins/docker-buildx
COPY --from=registry.hub.docker.com/docker/compose-bin /docker-compose ${HOME}/.docker/cli-plugins/docker-compose
COPY --from=tools-pixi /usr/local/bin/pixi ${PKG_HOME}/pixi
COPY --from=tools-pixi ${PIXI_HOME} ${PIXI_HOME}

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
