" defaults
set timeoutlen=400
set ignorecase
set smartcase
set number
set hidden
set cursorline
set cmdheight=2
set nowrap
set tabstop=4
set shiftwidth=4
set scrolloff=15
set list
set mouse=

let g:netrw_preview = 0
let g:netrw_alto = 1
let g:netrw_altfile = 1

noremap <silent> ' <Nop>
let g:mapleader = "'"
let g:maplocalleader = "'"

noremap <Space> :
nnoremap <silent> <Left> :vertical resize -4<CR>
nnoremap <silent> <Right> :vertical resize +4<CR>
nnoremap <silent> <Up> :resize +4<CR>
nnoremap <silent> <Down> :resize -4<CR>

nnoremap <silent> <leader>l! :set list!<CR>

if !has('nvim')
    set belloff=all
    set hlsearch
    set autoread
    set termguicolors
    set wildoptions=pum,tagfile
	if empty($XDG_STATE_HOME)
		" windows is weird
		set backupdir=$HOME/vimfiles/state/backup
		set directory=$HOME/vimfiles/state/swap
		set undodir=$HOME/vimfiles/state/undo
		set viminfofile=$HOME/vimfiles/state/.viminfo
	else
		set backupdir=$XDG_STATE_HOME/vim/backup
		set directory=$XDG_STATE_HOME/vim/swap
		set undodir=$XDG_STATE_HOME/vim/undo
		set viminfofile=$XDG_STATE_HOME/vim/.viminfo
	endif
    set viewoptions+=unix,slash
endif
" end defaults



" plugin conf
set completeopt-=preview
set completeopt+=menuone,noinsert,noselect
set shortmess+=c
nnoremap <silent> <leader>mm :MUcompleteAutoToggle<CR>
nnoremap <silent> <leader>ms :MUcompleteNotify 1<CR>
nnoremap <silent> <leader>mns :MUcompleteNotify 0<CR>
let g:mucomplete#enable_auto_at_startup = 1
let g:mucomplete#completion_delay = 500
let g:mucomplete#minimum_prefix_length = 1
let g:mucomplete#reopen_immediately = 0
let g:mucomplete#buffer_relative_paths = 1
let g:mucomplete#chains = {
    \ 'default': ['path', 'incl', 'omni'],
    \ 'vim': ['path', 'cmd', 'keyn']
\ }

if has('nvim')
    set packpath=$XDG_STATE_HOME/nvim/site
    set runtimepath=$XDG_STATE_HOME/nvim,$XDG_CONFIG_HOME/nvim,$VIMRUNTIME

    let g:polyglot_disabled = [
        \'bash.plugin',
        \'go.plugin',
        \'jsonc.plugin',
        \'lua.plugin',
        \'python.plugin',
        \'toml.plugin',
        \'terraform.plugin'
    \]
endif
let g:polyglot_disabled = ['sensible']
let g:polyglot_disabled = ['autoindent']
packadd! polyglot

if !has('nvim')
    packadd! flagship
    packadd! ansi-esc
    packadd! catppuccin-vim
    colorscheme catppuccin_mocha
endif
" end plugin conf



if has('nvim')
lua <<LUA
    vim.g.loaded_python_provider = 0 -- disable python2
    -- TODO: Figure out how to load providers from the conda env
    -- Also TODO: Do these even do anything worthwhile in 202X?
    vim.g.loaded_ruby_provider = 0
    vim.g.loaded_perl_provider = 0
    vim.g.loaded_node_provider = 0
    vim.g.loaded_python3_provider = 0

    require("plugins")
LUA
endif
