alias ls-raw='/bin/ls -lhA --color'

alias exa-ls='exa --binary --all --extended --classify --git --group-directories-first'
alias ls='exa-ls --long --tree --level=2'
alias lsg='exa-ls --long --grid'
alias lst='exa-ls --tree --level=4'