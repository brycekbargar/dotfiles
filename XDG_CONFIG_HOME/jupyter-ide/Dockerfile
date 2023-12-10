# syntax=docker/dockerfile:1

FROM quay.io/jupyter/minimal-notebook
RUN <<PKGS
mamba install --yes \
	black \
	isort \
	jedi-language-server \
	rich \
	jupyterlab_code_formatter \
	jupyterlab-lsp \
	jupyterlab_vim
mamba clean --all --force --yes

pip install --no-cache-dir \
	catppuccin-jupyterlab
PKGS

COPY --chown=1000:100 ./overrides.json /opt/conda/share/jupyter/lab/settings/overrides.json

RUN <<FIX
fix-permissions "${CONDA_DIR}"
fix-permissions "/home/${NB_USER}"
FIX
