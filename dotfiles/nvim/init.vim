call plug#begin('~/.config/nvim/plugged')

Plug 'tpope/vim-sensible'

Plug 'morhetz/gruvbox'
Plug 'vim-airline/vim-airline'

Plug 'scrooloose/syntastic'

Plug 'sheerun/vim-polyglot'

Plug 'brycekbargar/dotfiles', { 'rtp': 'dotfiles/nvim/shared', 'branch': 'multi-system-update' }

call plug#end()
