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

# Relocatable base
FROM debian AS conda-amd64
ADD https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh /tmp/miniconda-install.sh
FROM debian AS conda-arm64
ADD https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-aarch64.sh /tmp/miniconda-install.sh
FROM conda-${TARGETARCH} as base
ARG HOME
ARG CONDA_PREFIX="${HOME}/.local/var/lib/conda"
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

# Install tools written in go
FROM registry.hub.docker.com/library/golang as tools-go
RUN --mount=type=cache,target=/go/pkg,sharing=locked \
	go install github.com/mattn/efm-langserver@latest
# https://github.com/golang/go/issues/44840
# https://github.com/junegunn/fzf/commit/91bea9c5b311aa6a9919b814adc2fbb9405df2a5
RUN --mount=type=cache,target=/go/pkg,sharing=locked \
	go install github.com/junegunn/fzf@0.45.0
RUN --mount=type=cache,target=/go/pkg,sharing=locked \
	go install github.com/itchyny/gojq/cmd/gojq@latest
RUN --mount=type=cache,target=/go/pkg,sharing=locked \
	go install github.com/shihanng/gig@latest
RUN --mount=type=cache,target=/go/pkg,sharing=locked \
	go install github.com/lemonade-command/lemonade@latest
RUN --mount=type=cache,target=/go/pkg,sharing=locked \
	go install mvdan.cc/sh/v3/cmd/shfmt@latest
RUN --mount=type=cache,target=/go/pkg,sharing=locked \
	go install github.com/hashicorp/terraform-ls@latest
RUN --mount=type=cache,target=/go/pkg,sharing=locked \
	go install github.com/google/yamlfmt/cmd/yamlfmt@latest

# Install tools written in rust
# The target dir is split out so we can copy the bin and not get rust tools too
# --locked is intentionally left out to maximize cache hits
# Incremental and Rustc info help with cache hits too
FROM registry.hub.docker.com/library/rust:bookworm as tools-rust
ENV CARGO_CACHE_RUSTC_INFO=0
ENV CARGO_INCREMENTAL=1
ENV CARGO_HOME=/rust
RUN --mount=type=cache,target=/rust/registry,sharing=locked \
	cargo install bat
RUN --mount=type=cache,target=/rust/registry,sharing=locked \
	cargo install exa
RUN --mount=type=cache,target=/rust/registry,sharing=locked \
	cargo install fd-find
RUN --mount=type=cache,target=/rust/registry,sharing=locked \
	cargo install git-delta
RUN --mount=type=cache,target=/rust/registry,sharing=locked \
	cargo install precious
RUN --mount=type=cache,target=/rust/registry,sharing=locked \
	cargo install ripgrep
RUN --mount=type=cache,target=/rust/registry,sharing=locked \
	cargo install stylua
RUN --mount=type=cache,target=/rust/registry,sharing=locked \
	cargo install taplo-cli --features lsp

# Install tools written in python
FROM tools-rust as tools-python
RUN --mount=type=cache,target=/rust/registry,sharing=locked \
	cargo install --git https://github.com/mitsuhiko/rye rye
ARG PKG_HOME
ENV RYE_HOME="${PKG_HOME}/.rye"
RUN <<RYE
/rust/bin/rye install awscli
/rust/bin/rye install pipx
/rust/bin/rye install pre-commit-hooks
/rust/bin/rye install yamllint

# This doesn't seem to matter to the installed tools and we don't need it
/rust/bin/rye toolchain remove $(
	/rust/bin/rye toolchain list |
	sort | head -1 |
	awk '{print $1}')
rm -fdr \
	"$RYE_HOME/shims/python" \
	"$RYE_HOME/shims/python3" \
	"$RYE_HOME/self"
RYE

# Install tools written in javascript
FROM debian as tools-js
ARG PKG_HOME
ENV N_PREFIX="${PKG_HOME}/.tjn"
ENV N_CACHE_PREFIX="/tmp"
ADD https://raw.githubusercontent.com/tj/n/master/bin/n /usr/bin/n
RUN chmod +x /usr/bin/n
RUN <<TJN
n latest
export PATH=$N_PREFIX/bin:$PATH
npm install -g npm@latest
npm install -g \
	@ansible/ansible-language-server \
	@astrojs/language-server \
	bash-language-server \
	@bitwarden/cli \
	dockerfile-language-server-nodejs \
	fixjson \
	pyright \
	@tailwindcss/language-server \
	tiged \
	typescript-language-server \
	typescript \
	vscode-langservers-extracted \
	yaml-language-server

rm $N_PREFIX/bin/npm
TJN

# Build out the base of the final image
FROM debian as dev-container
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
install --owner 1111 --group 1111 -D --directory /opt/conda/envs /opt/conda/pkgs
NONROOT

FROM dev-container as ansible
ARG HOME
ARG CONDA_PREFIX="${HOME}/.local/var/lib/conda"
ARG SETUP=${HOME}/_setup

COPY --chown=1111:1111 --from=base ${CONDA_PREFIX}/base ${CONDA_PREFIX}/base
COPY --chown=1111:1111 ./dotfiles ${SETUP}/dotfiles
COPY --chown=1111:1111 ./private ${SETUP}/private

ARG HOSTOS
# The Ansible playbook uses this
ENV HOSTOS=${HOSTOS}
WORKDIR ${SETUP}/dotfiles
USER 1111:1111
RUN --mount=type=cache,target=${HOME}/.local/var/cache  <<ANSIBLE
#! /usr/bin/zsh
sudo chown 1111:1111 ${HOME}/.local/var/cache
source "${SETUP}/dotfiles/.zshenv"
source <("${CONDA_PREFIX}/base/bin/conda" shell.zsh hook)
conda create --quiet --yes --prefix /tmp/ansible --channel=conda-forge python ansible jmespath
ANSIBLE_CONFIG="$(pwd)/playbooks/ansible.cfg" \
	conda run --prefix /tmp/ansible --no-capture-output \
	ansible-playbook "playbooks/default.playbook.yml"
# TODO: Figure out how to do this in the playbook
source "$ZDOTDIR/myrc.zsh"
fast-theme base16
ANSIBLE

# This is for any final IO operations needed before squashing the final image into a single layer
FROM ansible as home-layer
ARG HOME
ARG PKG_HOME
COPY --from=registry.hub.docker.com/library/docker:cli /usr/local/bin/docker ${HOME}/.local/bin/docker
COPY --from=registry.hub.docker.com/docker/buildx-bin /buildx ${HOME}/.docker/cli-plugins/docker-buildx
COPY --from=tools-go /go/bin/ ${PKG_HOME}/
COPY --from=tools-rust /rust/bin/ ${PKG_HOME}/
COPY --from=tools-python ${PKG_HOME}/.rye ${PKG_HOME}/.rye
COPY --from=tools-js ${PKG_HOME}/.tjn ${PKG_HOME}/.tjn


FROM dev-container
ARG HOME
COPY --chown=1111:1111 --from=home-layer ${HOME} ${HOME}
WORKDIR ${HOME}/code
# XDG_STATE_HOME, XDG_CACHE_HOME, and /tmp should have most of the container writes
# Having them set to be an anon volume keeps the container size down at runtime
VOLUME ${HOME}/.local/var
VOLUME /tmp

ENTRYPOINT ["/usr/bin/zsh", "-i"]
