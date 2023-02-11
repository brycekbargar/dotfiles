ARG USER=bryce
ARG DOTFILES_LOCATION=remote

FROM registry.hub.docker.com/library/debian:testing AS base
ARG USER
RUN \
	apt-get update && \
	apt-get autoclean && \
	apt-get clean && \
	apt-get autoremove
RUN apt-get install --yes \
	apt-transport-https \
	build-essential \
	ca-certificates \
	curl \
	git \
	gnupg \
	libssl-dev \
	pkg-config \
	software-properties-common \
	sudo \
	unzip \
	vim \
	zsh
RUN \
	groupadd --gid 1000 "${USER}" && \
	useradd --uid 1000 --gid 1000 -s /usr/bin/zsh -m "${USER}" && \
	passwd -d "${USER}" && \
	usermod -aG sudo "${USER}"
USER ${USER}
ENTRYPOINT ["/usr/bin/zsh", "-i"]

FROM base AS conda-amd64
ADD --chown=1000:1000 https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh /tmp/miniconda-install.sh

FROM base AS conda-arm64
ADD --chown=1000:1000 https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-aarch64.sh /tmp/miniconda-install.sh

FROM conda-${TARGETARCH} AS dotfiles-remote
ARG DOTFILES_BRANCH=main
RUN git clone -b "${DOTFILES_BRANCH}" https://github.com/brycekbargar/dotfiles.git ~/_src/dotfiles

FROM conda-${TARGETARCH} AS dotfiles-local
ARG USER
COPY --chown=1000:1000 . "/home/${USER}/_src/dotfiles"

FROM dotfiles-${DOTFILES_LOCATION} as ansible
ARG USER
WORKDIR /home/${USER}/_src/dotfiles
RUN git clean -fdX
RUN ln -s ~/_src/dotfiles/.zshenv ~/.zshenv
RUN mkdir -p ~/_setup ~/code \
	~/.local/opt \
	~/.local/share \
	~/.local/var/cache \
	~/.local/var/lib
# TODO: Remove ths when conda fixes the installation script (also the -f in the install)
RUN mkdir -p ~/.local/share/conda/base/pkgs/envs/*
RUN /usr/bin/zsh /tmp/miniconda-install.sh -b -s -f -p "/home/${USER}/.local/share/conda/base"
RUN /usr/bin/zsh ./tea.sh
