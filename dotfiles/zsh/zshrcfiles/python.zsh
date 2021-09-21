# pyenv
export PYENV_ROOT="$HOME/.pyenv"
export PYTHONUSERBASE="$HOME/.pipenv"
export PATH="$PYENV_ROOT/bin:$PYTHONUSERBASE/bin:$PATH"
eval "$(pyenv init --path)"
eval "$(pyenv init -)"

pip install --quiet --user --upgrade pipenv