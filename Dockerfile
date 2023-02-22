ARG USER=bryce
ARG HOME="/home/${USER}"
ARG CONDA_PREFIX="${HOME}/.local/var/lib/conda"

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
RUN --mount=type=cache,target=/opt/conda/pkgs,sharing=locked \
        "${CONDA_PREFIX}/base/bin/conda" config --add channels conda-forge && \
        "${CONDA_PREFIX}/base/bin/conda" update --yes --quiet --name base conda --all && \
        "${CONDA_PREFIX}/base/bin/conda" install --yes --quiet --name base \
		conda-libmamba-solver \
		micromamba \
		conda-lock

# Mamba system environments builder
FROM registry.hub.docker.com/continuumio/miniconda3 as mamba
RUN --mount=type=cache,target=/opt/conda/pkgs,sharing=locked \
        conda config --add channels conda-forge && \
        conda update --yes --quiet --name base conda --all && \
        conda install --yes --quiet --name base conda-libmamba-solver && \
        conda config --set solver libmamba

# System environments
# the conda_pkgs_dir varies by likelihood of shared pkgs
#   it can fill up if all the envs share a dir and gc in between instructions : /
FROM mamba as runtimes-python
ARG ENV_NAME="runtimes-python"
ARG CONDA_PREFIX
COPY ./dotfiles-dev-container/XDG_CONFIG_HOME/conda/${ENV_NAME}.yml environment.yml
RUN --mount=type=cache,target=/python,sharing=locked \
        CONDA_PKGS_DIR="/python" conda env create --quiet --prefix "${CONDA_PREFIX}/${ENV_NAME}" --file environment.yml

FROM mamba as dotfiles
ARG CONDA_PREFIX
COPY ./dotfiles-dev-container/environment.yml environment.yml
RUN --mount=type=cache,target=/python,sharing=locked \
        CONDA_PKGS_DIR="/python" conda env create --quiet --prefix "${CONDA_PREFIX}/dotfiles" --file environment.yml

FROM mamba as toolchains-go
ARG ENV_NAME="toolchains-go"
ARG CONDA_PREFIX
COPY ./dotfiles-dev-container/XDG_CONFIG_HOME/conda/${ENV_NAME}.yml environment.yml
RUN --mount=type=cache,target=/compilers,sharing=locked \
        CONDA_PKGS_DIR="/compilers" conda env create --quiet --prefix "${CONDA_PREFIX}/${ENV_NAME}" --file environment.yml

FROM mamba as toolchains-rust
ARG ENV_NAME="toolchains-rust"
ARG CONDA_PREFIX
COPY ./dotfiles-dev-container/XDG_CONFIG_HOME/conda/${ENV_NAME}.yml environment.yml
RUN --mount=type=cache,target=/compilers,sharing=locked \
        CONDA_PKGS_DIR="/compilers" conda env create --quiet --prefix "${CONDA_PREFIX}/${ENV_NAME}" --file environment.yml

FROM mamba as runtimes-nodejs
ARG ENV_NAME="runtimes-nodejs"
ARG CONDA_PREFIX
COPY ./dotfiles-dev-container/XDG_CONFIG_HOME/conda/${ENV_NAME}.yml environment.yml
RUN --mount=type=cache,target=/nodejs,sharing=locked \
        CONDA_PKGS_DIR="/nodejs" conda env create --quiet --prefix "${CONDA_PREFIX}/${ENV_NAME}" --file environment.yml
RUN --mount=type=cache,target=/root/.npm,sharing=locked \
        conda run --prefix "${CONDA_PREFIX}/${ENV_NAME}" npm install -g npm@latest

FROM mamba as nvim
ARG ENV_NAME="nvim"
ARG CONDA_PREFIX
COPY ./dotfiles-dev-container/XDG_CONFIG_HOME/nvim/environment.yml environment.yml
RUN --mount=type=cache,target=/nodejs,sharing=locked \
        CONDA_PKGS_DIR="/nodejs" conda env create --quiet --prefix "${CONDA_PREFIX}/${ENV_NAME}" --file environment.yml
RUN --mount=type=cache,target=/root/.npm,sharing=locked \
        conda run --prefix "${CONDA_PREFIX}/${ENV_NAME}" npm install -g npm@latest

# Smush together all the conda system environments
FROM scratch AS conda-prefix
ARG CONDA_PREFIX
COPY --from=base ${CONDA_PREFIX}/base ${CONDA_PREFIX}/base
COPY --from=dotfiles ${CONDA_PREFIX}/dotfiles ${CONDA_PREFIX}/dotfiles
COPY --from=runtimes-python ${CONDA_PREFIX}/runtimes-python ${CONDA_PREFIX}/runtimes-python
COPY --from=toolchains-go ${CONDA_PREFIX}/toolchains-go ${CONDA_PREFIX}/toolchains-go
COPY --from=toolchains-rust ${CONDA_PREFIX}/toolchains-rust ${CONDA_PREFIX}/toolchains-rust
COPY --from=runtimes-nodejs ${CONDA_PREFIX}/runtimes-nodejs ${CONDA_PREFIX}/runtimes-nodejs
COPY --from=nvim ${CONDA_PREFIX}/nvim ${CONDA_PREFIX}/nvim

# Build out the final image
FROM scratch as setup
COPY ./dotfiles-dev-container /dotfiles
COPY ./private /private
FROM debian as dev-container
RUN apt-get update && apt-get install --no-install-recommends --yes \
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
	zsh \
	&& rm -rf /var/lib/apt/lists/*
# Non root user and persistent volumes
ARG HOME
ARG USER
ARG CODE="${HOME}/_src"
RUN \
	groupadd --gid 1111 "${USER}" && \
	useradd --no-log-init --uid 1111 --gid 1111 -s /usr/bin/zsh -m "${USER}" -d "${HOME}" && \
	passwd -d "${USER}" && \
	usermod -aG sudo "${USER}" && \
	mkdir -p /etc/sudoers.d && \
	echo "$USER ALL=(ALL) NOPASSWD: ALL" > "/etc/sudoers.d/${USER}" && \
	chmod 0440 "/etc/sudoers.d/${USER}" && \
	mkdir -p /conda/pkgs /conda/envs "${CODE}" && \
	chown -R 1111:1111 /conda "${CODE}"
# Source repos and the conda environments for them go outside the container
VOLUME ["/conda/pkgs", "/conda/envs", "${CODE}" ]
USER 1111:1111

ARG CONDA_PREFIX
COPY --chown=1111:1111 --from=conda-prefix ${CONDA_PREFIX} ${CONDA_PREFIX}

ARG SETUP="${HOME}/_setup"
COPY --chown=1111:1111 --from=setup / ${SETUP}
WORKDIR ${SETUP}/dotfiles
# Removing the cache slims the image size
RUN ln -s "${SETUP}/dotfiles/.zshenv" "${HOME}/.zshenv" && \
	/usr/bin/zsh tea.sh && \
	# go mod files don't have the write bit set so we set it before deletion
	chmod +w -R "${HOME}/.local/var/cache/go-mod" && \
	rm -fdr "${HOME}/.local/var/cache"

WORKDIR ${CODE}
ENTRYPOINT ["/usr/bin/zsh", "-i"]
