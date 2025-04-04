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

" https://github.com/BurntSushi/ripgrep/issues/425
if executable('rg') | set grepformat^=%f:%l:%c:%m grepprg=rg\ --vimgrep | endif
" https://noahfrederick.com/log/vim-streamlining-grep
cnoreabbrev <expr> grep  (getcmdtype() ==# ':' && getcmdline() =~# '^grep')  ? 'silent grep'  : 'grep'
cnoreabbrev <expr> lgrep (getcmdtype() ==# ':' && getcmdline() =~# '^lgrep') ? 'silent lgrep' : 'lgrep'
augroup TweakQuickFix
  autocmd!
  autocmd QuickFixCmdPost [^l]* cwindow
  autocmd QuickFixCmdPost l* lwindow
augroup END

if !has('nvim')
    set belloff=all
    set hlsearch
    set autoread
    set termguicolors
    set showtabline=1
    set wildoptions=pum,tagfile
	if empty($XDG_STATE_HOME)
		if has('win64')
			" windows is weird
			set backupdir=$HOME/vimfiles/state/backup
			set directory=$HOME/vimfiles/state/swap
			set undodir=$HOME/vimfiles/state/undo
			set viminfofile=$HOME/vimfiles/state/.viminfo
		endif
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
if has('nvim')
    set packpath=$XDG_STATE_HOME/nvim/site,$VIMRUNTIME
    set runtimepath=$XDG_STATE_HOME/nvim,$XDG_CONFIG_HOME/nvim,$VIMRUNTIME
endif

set completeopt-=preview
set completeopt+=menuone,noinsert,noselect
set shortmess+=c
nnoremap <silent> <leader>mm :MUcompleteAutoToggle<CR>
let g:mucomplete#enable_auto_at_startup = 1
let g:mucomplete#completion_delay = 500
let g:mucomplete#minimum_prefix_length = 1
let g:mucomplete#buffer_relative_paths = 1
" TODO: Make this only applicable to nvim lsp buffers
let g:mucomplete#chains = { 'default': ['path', 'incl', 'omni'] }

if !has('nvim')
    packadd! catppuccin-vim
    colorscheme catppuccin_mocha
endif
" end plugin conf

if has('nvim')
lua <<LUA
    vim.g.clipboard = 'osc52'
    vim.g.loaded_python_provider = 0
    vim.g.loaded_ruby_provider = 0
    vim.g.loaded_perl_provider = 0
    vim.g.loaded_node_provider = 0
    vim.g.loaded_python3_provider = 0

    require("plugins")
LUA
endif
