# syntax=docker/dockerfile:1

FROM quay.io/jupyter/minimal-notebook
RUN <<PKGS
mamba install --yes \
	black \
	isort \
	graphviz \
	jedi-language-server \
	rich \
	jupyterlab_code_formatter \
	jupyterlab-lsp \
	jupyterlab_vim \
	jupytext
mamba clean --all --force --yes

pip install --no-cache-dir \
	catppuccin-jupyterlab
PKGS

RUN <<PRE
cat <<CSS >> /opt/conda/share/jupyter/labextensions/catppuccin_jupyterlab/themes/catppuccin_jupyterlab/index.css
.jp-RenderedText pre {
  font-family: 'Delugia Book';
  font-size: 18px;
}

.jp-RenderedHTML :is(th, td) {
  font-family: 'Delugia Book';
  font-size: 18px;
}

.jp-RenderedText[data-mime-type='application/vnd.jupyter.stderr'] {
  background-color: inherit;
  & pre {
    font-size: 14px;
  }
}
CSS
PRE

COPY --chown=1000:100 ./overrides.json /opt/conda/share/jupyter/lab/settings/overrides.json

RUN <<FIX
fix-permissions "${CONDA_DIR}"
fix-permissions "/home/${NB_USER}"
FIX
