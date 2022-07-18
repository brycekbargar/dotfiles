" defaults
set timeoutlen=400
set ignorecase
set smartcase
set number
set hidden
set cursorline
set cmdheight=2
set nowrap
set shiftwidth=4
set scrolloff=15
set list

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
    set wildoptions=pum,tagfile
	if empty($XDG_STATE_HOME)
		set backupdir=$HOME/.vim/state/backup
		set directory=$HOME/.vim/state/swap
		set undodir=$HOME/.vim/state/undo
	else
		set backupdir=$XDG_STATE_HOME/vim/backup
		set directory=$XDG_STATE_HOME/vim/swap
		set undodir=$XDG_STATE_HOME/vim/undo
	endif
    set viewoptions+=unix,slash
endif
" end defaults



" plugin conf
set completeopt-=preview
set completeopt+=menuone,noinsert,noselect
set shortmess+=c
nnoremap <silent> <leader>lm :MUcompleteAutoToggle<CR>
let g:mucomplete#enable_auto_at_startup = 1

if has('nvim')
    let g:polyglot_disabled = [
	\'bash.plugin',
        \'go.plugin',
        \'terraform.plugin',
        \'jsonc.plugin',
        \'lua.plugin',
        \'python.plugin',
        \'rst.plugin',
        \'toml.plugin'
    \]
endif
let g:polyglot_disabled = ['sensible']
packadd! polyglot

if !has('nvim')
    packadd! flagship

    set termguicolors
    packadd! catppuccin-vim
    colorscheme catppuccin_latte
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
