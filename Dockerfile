ARG USER=bryce
ARG HOME="/home/${USER}"
ARG CONDA_PREFIX="${HOME}/.local/var/lib/conda"
ARG DOTFILES_LOCATION=remote
ARG DOTFILES_DIRECTORY=dotfiles

# Relocatable base
FROM registry.hub.docker.com/library/debian:testing-slim AS conda-amd64
ADD https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh /tmp/miniconda-install.sh

FROM registry.hub.docker.com/library/debian:testing-slim AS conda-arm64
ADD https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-aarch64.sh /tmp/miniconda-install.sh

FROM conda-${TARGETARCH} as base
ARG CONDA_PREFIX
RUN chmod +x /tmp/miniconda-install.sh
RUN --mount=type=cache,target=/opt/conda/pkgs \
        /tmp/miniconda-install.sh -b -s -p "${CONDA_PREFIX}/base"
RUN --mount=type=cache,target=/opt/conda/pkgs \
        "${CONDA_PREFIX}/base/bin/conda" config --add channels conda-forge && \
        "${CONDA_PREFIX}/base/bin/conda" update --yes --quiet --name base conda --all && \
        "${CONDA_PREFIX}/base/bin/conda" install --yes --quiet --name base \
		conda-libmamba-solver \
		micromamba \
		conda-lock

# build out the system conda environments
# the conda_pkgs_dir varies by likelihood of shared pkgs
#   it can fill up if all the envs share a dir and gc in between instructions : /
FROM registry.hub.docker.com/continuumio/miniconda3 as mamba
RUN --mount=type=cache,target=/opt/conda/pkgs \
        conda config --add channels conda-forge && \
        conda update --yes --quiet --name base conda --all && \
        conda install --yes --quiet --name base conda-libmamba-solver && \
        conda config --set solver libmamba

FROM mamba as runtimes-python
ARG ENV_NAME="runtimes-python"
ARG CONDA_PREFIX
ARG DOTFILES_DIRECTORY
COPY ${DOTFILES_DIRECTORY}/XDG_CONFIG_HOME/conda/${ENV_NAME}.yml environment.yml
RUN --mount=type=cache,target=/python \
        CONDA_PKGS_DIR="/python" conda env create --quiet --prefix "${CONDA_PREFIX}/${ENV_NAME}" --file environment.yml

FROM mamba as dotfiles
ARG CONDA_PREFIX
ARG DOTFILES_DIRECTORY
COPY ${DOTFILES_DIRECTORY}/environment.yml environment.yml
RUN --mount=type=cache,target=/python \
        CONDA_PKGS_DIR="/python" conda env create --quiet --prefix "${CONDA_PREFIX}/dotfiles" --file environment.yml

FROM mamba as toolchains-go
ARG ENV_NAME="toolchains-go"
ARG CONDA_PREFIX
ARG DOTFILES_DIRECTORY
COPY ${DOTFILES_DIRECTORY}/XDG_CONFIG_HOME/conda/${ENV_NAME}.yml environment.yml
RUN --mount=type=cache,target=/compilers \
        CONDA_PKGS_DIR="/compilers" conda env create --quiet --prefix "${CONDA_PREFIX}/${ENV_NAME}" --file environment.yml

FROM mamba as toolchains-rust
ARG ENV_NAME="toolchains-rust"
ARG CONDA_PREFIX
ARG DOTFILES_DIRECTORY
COPY ${DOTFILES_DIRECTORY}/XDG_CONFIG_HOME/conda/${ENV_NAME}.yml environment.yml
RUN --mount=type=cache,target=/compilers \
        CONDA_PKGS_DIR="/compilers" conda env create --quiet --prefix "${CONDA_PREFIX}/${ENV_NAME}" --file environment.yml

FROM mamba as runtimes-nodejs
ARG ENV_NAME="runtimes-nodejs"
ARG CONDA_PREFIX
ARG DOTFILES_DIRECTORY
COPY ${DOTFILES_DIRECTORY}/XDG_CONFIG_HOME/conda/${ENV_NAME}.yml environment.yml
RUN --mount=type=cache,target=/nodejs \
        CONDA_PKGS_DIR="/nodejs" conda env create --quiet --prefix "${CONDA_PREFIX}/${ENV_NAME}" --file environment.yml
RUN --mount=type=cache,target=/root/.npm \
        conda run --prefix "${CONDA_PREFIX}/${ENV_NAME}" npm install -g npm@latest

FROM mamba as nvim
ARG ENV_NAME="nvim"
ARG CONDA_PREFIX
ARG DOTFILES_DIRECTORY
COPY ${DOTFILES_DIRECTORY}/XDG_CONFIG_HOME/nvim/environment.yml environment.yml
RUN --mount=type=cache,target=/nodejs \
        CONDA_PKGS_DIR="/nodejs" conda env create --quiet --prefix "${CONDA_PREFIX}/${ENV_NAME}" --file environment.yml
RUN --mount=type=cache,target=/root/.npm \
        conda run --prefix "${CONDA_PREFIX}/${ENV_NAME}" npm install -g npm@latest

# Build out the final image
FROM registry.hub.docker.com/library/debian:testing-slim as dev-container
ARG USER
RUN apt-get update && apt-get install --yes \
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
RUN \
	groupadd --gid 1000 "${USER}" && \
	useradd --uid 1000 --gid 1000 -s /usr/bin/zsh -m "${USER}" && \
	passwd -d "${USER}" && \
	usermod -aG sudo "${USER}"
ENTRYPOINT ["/usr/bin/zsh", "-i"]

RUN mkdir /conda && chown 1000:1000 /conda
VOLUME ["/conda/pkgs", "/conda/envs"]
USER 1000:1000

ARG CONDA_PREFIX
COPY --chown=1000:1000 --from=base ${CONDA_PREFIX}/base ${CONDA_PREFIX}/base
COPY --chown=1000:1000 --from=dotfiles ${CONDA_PREFIX}/dotfiles ${CONDA_PREFIX}/dotfiles
COPY --chown=1000:1000 --from=runtimes-python ${CONDA_PREFIX}/runtimes-python ${CONDA_PREFIX}/runtimes-python
COPY --chown=1000:1000 --from=runtimes-nodejs ${CONDA_PREFIX}/runtimes-nodejs ${CONDA_PREFIX}/runtimes-nodejs
COPY --chown=1000:1000 --from=toolchains-go ${CONDA_PREFIX}/toolchains-go ${CONDA_PREFIX}/toolchains-go
COPY --chown=1000:1000 --from=toolchains-rust ${CONDA_PREFIX}/toolchains-rust ${CONDA_PREFIX}/toolchains-rust
COPY --chown=1000:1000 --from=nvim ${CONDA_PREFIX}/nvim ${CONDA_PREFIX}/nvim

FROM dev-container AS dotfiles-remote
ARG HOME
ARG DOTFILES_BRANCH=main
RUN git clone -b "${DOTFILES_BRANCH}" "https://github.com/brycekbargar/dotfiles.git" "${HOME}/_src/dotfiles"

FROM dev-container AS dotfiles-local
ARG HOME
ARG DOTFILES_DIRECTORY
COPY --chown=1000:1000 ${DOTFILES_DIRECTORY} "${HOME}/_src/dotfiles"

FROM dotfiles-${DOTFILES_LOCATION}
ARG HOME
WORKDIR ${HOME}/_src/dotfiles
RUN ln -s ~/_src/dotfiles/.zshenv ~/.zshenv
RUN --mount=type=tmpfs,target="${HOME}/.local/var/cache" \
	/usr/bin/zsh ./tea.sh
