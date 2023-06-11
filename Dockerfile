# syntax=docker/dockerfile:1

# Environment specific args
ARG USER=bryce
ARG DOCKER_GROUP=1001
ARG HOSTOS=windows

# Shortcuts shared across multiple stages
ARG HOME="/home/${USER}"
ARG CONDA_PREFIX="${HOME}/.local/var/lib/conda"
ARG RYE_HOME="${HOME}/.local/opt/.rye"

FROM registry.hub.docker.com/library/debian:testing-slim AS debian

# Relocatable base
FROM debian AS conda-amd64
ADD https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh /tmp/miniconda-install.sh
FROM debian AS conda-arm64
ADD https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-aarch64.sh /tmp/miniconda-install.sh
FROM conda-${TARGETARCH} as base
ARG CONDA_PREFIX
RUN chmod +x /tmp/miniconda-install.sh
RUN --mount=type=cache,target=/opt/conda/pkgs,sharing=locked \
        /tmp/miniconda-install.sh -b -s -p "${CONDA_PREFIX}/base"
RUN --mount=type=cache,target=/opt/conda/pkgs,sharing=locked <<UPDATE
"${CONDA_PREFIX}/base/bin/conda" config --add channels conda-forge
"${CONDA_PREFIX}/base/bin/conda" update --yes --quiet --name base conda --all
"${CONDA_PREFIX}/base/bin/conda" install --yes --quiet --name base \
	conda-libmamba-solver \
	micromamba \
	conda-lock
UPDATE

# Mamba system environments builder
FROM registry.hub.docker.com/continuumio/miniconda3 as mamba
RUN --mount=type=cache,target=/opt/conda/pkgs,sharing=locked <<MAMBA
conda config --add channels conda-forge
conda update --yes --quiet --name base conda --all
conda install --yes --quiet --name base conda-libmamba-solver
conda config --set solver libmamba
MAMBA

# System environments
# the conda_pkgs_dir varies by likelihood of shared pkgs
#   it can fill up if all the envs share a dir and gc in between instructions : /
FROM mamba as dotfiles
ARG ENV_NAME="dotfiles"
ARG CONDA_PREFIX
COPY ./dotfiles/environment.yml environment.yml
RUN --mount=type=cache,target=/python,sharing=locked \
        CONDA_PKGS_DIR="/python" conda env create --quiet --prefix "${CONDA_PREFIX}/${ENV_NAME}" --file environment.yml

FROM mamba as runtimes-nodejs
ARG ENV_NAME="runtimes-nodejs"
ARG CONDA_PREFIX
COPY ./dotfiles/XDG_CONFIG_HOME/conda/${ENV_NAME}.yml environment.yml
RUN --mount=type=cache,target=/nodejs,sharing=locked \
        CONDA_PKGS_DIR="/nodejs" conda env create --quiet --prefix "${CONDA_PREFIX}/${ENV_NAME}" --file environment.yml
RUN --mount=type=cache,target=/root/.npm,sharing=locked \
        conda run --prefix "${CONDA_PREFIX}/${ENV_NAME}" npm install -g npm@latest

# Install tools written in go
FROM registry.hub.docker.com/library/golang as tools-go
RUN --mount=type=cache,target=/go/pkg,sharing=locked \
	go install github.com/junegunn/fzf@latest
RUN --mount=type=cache,target=/go/pkg,sharing=locked \
	go install github.com/itchyny/gojq/cmd/gojq@latest
RUN --mount=type=cache,target=/go/pkg,sharing=locked \
	go install github.com/shihanng/gig@latest
RUN --mount=type=cache,target=/go/pkg,sharing=locked \
	go install github.com/lemonade-command/lemonade@latest

# Install tools written in rust
# The target dir is split out so we can copy the bin and not get rust tools too
# --locked is intentionally left out to maximize cache hits
# Incremental and Rustc info help with cache hits too
FROM registry.hub.docker.com/library/rust:bookworm as tools-rust
ENV CARGO_CACHE_RUSTC_INFO=0
ENV CARGO_INCREMENTAL=1
ENV CARGO_HOME=/rust
RUN --mount=type=cache,target=/rust/registry,sharing=locked \
	cargo install fd-find
RUN --mount=type=cache,target=/rust/registry,sharing=locked \
	cargo install exa
RUN --mount=type=cache,target=/rust/registry,sharing=locked \
	cargo install ripgrep
RUN --mount=type=cache,target=/rust/registry,sharing=locked \
	cargo install git-delta
RUN --mount=type=cache,target=/rust/registry,sharing=locked \
	cargo install bat
RUN --mount=type=cache,target=/rust/registry,sharing=locked \
	cargo install precious
RUN --mount=type=cache,target=/rust/registry,sharing=locked \
	cargo install --git https://github.com/mitsuhiko/rye rye

# Install tools written in python
FROM tools-rust as tools-python
ARG RYE_HOME
ENV RYE_HOME="${RYE_HOME}"
RUN /rust/bin/rye install awscli
RUN /rust/bin/rye install thefuck
RUN /rust/bin/rye install pipx
# This doesn't seem to matter to rye or installed tools
RUN rm ${RYE_HOME}/shims/python ${RYE_HOME}/shims/python3

# These are used for nvim (linters and lsps)
# They're in a separate build stage to they can get copied into the bin/ide folder
FROM registry.hub.docker.com/library/golang as nvim-go
RUN --mount=type=cache,target=/go/pkg,sharing=locked \
	go install github.com/terraform-linters/tflint@latest
RUN --mount=type=cache,target=/go/pkg,sharing=locked \
	go install github.com/hashicorp/terraform-ls@latest
RUN --mount=type=cache,target=/go/pkg,sharing=locked \
	go install mvdan.cc/sh/v3/cmd/shfmt@latest
FROM registry.hub.docker.com/library/rust:bookworm as nvim-rust
ENV CARGO_CACHE_RUSTC_INFO=0
ENV CARGO_INCREMENTAL=1
ENV CARGO_HOME=/rust
RUN --mount=type=cache,target=/rust/registry,sharing=locked \
	cargo install taplo-cli --features lsp
RUN --mount=type=cache,target=/rust/registry,sharing=locked \
	cargo install stylua

# Build out the base of the final image
FROM debian as dev-container
RUN <<APT
apt-get update
apt-get install --no-install-recommends --yes \
	build-essential \
	ca-certificates \
	curl \
	git \
	less \
	libncursesw6 \
	openssh-client \
	shellcheck \
	sudo \
	unzip \
	vim \
	vim-doc \
	zsh
rm -rf /var/lib/apt/lists/*
APT
ARG USER
ARG DOCKER_GROUP
# bash is necessary here for the install command
# install makes it easy to create/mod/own the files in a single command
RUN <<NONROOT
#! /usr/bin/env bash
groupadd --gid ${DOCKER_GROUP} docker
groupadd --gid 1111 "${USER}"
useradd --no-log-init --shell /usr/bin/zsh --create-home \
	--uid 1111 --gid 1111 "${USER}"
passwd --delete "${USER}"
usermod --append --groups sudo,docker "${USER}"
install --mode 0440 -D <(echo "$USER ALL=(ALL) NOPASSWD: ALL") "/etc/sudoers.d/${USER}"
# These should be mounted as volumes at runtime but don't fail if they're missing
install --owner 1111 --group 1111 -D --directory /conda/envs /conda/pkgs
NONROOT

FROM dev-container as ansible
ARG HOME
ARG CONDA_PREFIX
ARG SETUP=${HOME}/_setup

COPY --chown=1111:1111 --from=base ${CONDA_PREFIX}/base ${CONDA_PREFIX}/base
COPY --chown=1111:1111 --from=dotfiles ${CONDA_PREFIX}/dotfiles ${CONDA_PREFIX}/dotfiles
COPY --chown=1111:1111 ./dotfiles ${SETUP}/dotfiles
COPY --chown=1111:1111 ./private ${SETUP}/private

ARG HOSTOS
# The Ansible playbook uses this
ENV HOSTOS=${HOSTOS}
WORKDIR ${SETUP}/dotfiles
USER 1111:1111
RUN --mount=type=cache,target=${HOME}/.local/var/cache <<ANSIBLE
#! /usr/bin/zsh
sudo chown 1111:1111 ${HOME}/.local/var/cache
source "${SETUP}"/dotfiles/.zshenv
source <("${CONDA_PREFIX}/base/bin/conda" shell.zsh hook)
ANSIBLE_CONFIG="$(pwd)/playbooks/ansible.cfg" \
	conda run --name dotfiles --no-capture-output \
	ansible-playbook "playbooks/default.playbook.yml"
# TODO: Figure out how to do this in the playbook
source "$ZDOTDIR"/myrc.zsh
ANSIBLE

# This is for any final IO operations that need to to squash final image into a single layer
FROM ansible as home-layer
ARG HOME
ARG CONDA_PREFIX
ARG RYE_HOME
COPY --from=registry.hub.docker.com/library/docker:cli /usr/local/bin/docker ${HOME}/.local/bin/docker
COPY --from=tools-go /go/bin/ ${HOME}/.local/opt/
COPY --from=tools-rust /rust/bin/ ${HOME}/.local/opt/
COPY --from=tools-python ${RYE_HOME} ${RYE_HOME}
COPY --from=nvim-go /go/bin/ ${HOME}/.nvim/
COPY --from=nvim-rust /rust/bin/ ${HOME}/.nvim/
COPY --from=runtimes-nodejs ${CONDA_PREFIX}/runtimes-nodejs ${CONDA_PREFIX}/runtimes-nodejs
# This isn't necessary to keep in the container
RUN rm -fdr ${CONDA_PREFIX}/dotfiles


FROM dev-container
ARG HOME
COPY --chown=1111:1111 --from=home-layer ${HOME} ${HOME}
WORKDIR ${HOME}/code
# XDG_STATE_HOME and XDG_CACHE_HOME should have most of the container writes
# Having it set to be an anon volume keeps the container size down at runtime
VOLUME ${HOME}/.local/var

ENTRYPOINT ["/usr/bin/zsh", "-i"]
