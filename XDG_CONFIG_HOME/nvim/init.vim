set timeoutlen=400
set ignorecase
set smartcase
set number
set cursorline
set cmdheight=2
set nowrap
set tabstop=4

noremap <silent> ' <Nop>
let g:mapleader = "'"
let g:maplocalleader = "'"

noremap <Space> :
nnoremap <silent> <Left> :vertical resize -4<CR>
nnoremap <silent> <Right> :vertical resize +4<CR>
nnoremap <silent> <Up> :resize +4<CR>
nnoremap <silent> <Down> :resize -4<CR>

let g:netrw_preview = 0
let g:netrw_alto = 1
let g:netrw_altfile = 1

if !has('nvim')
    set hidden
    set belloff=all
    set hlsearch
    set wildoptions=pum,tagfile
    set backupdir=$XDG_STATE_HOME/vim/backup
    set directory=$XDG_STATE_HOME/vim/swap
    set undodir=$XDG_STATE_HOME/vim/undo
    set viewoptions+=unix,slash

    nnoremap <silent> <leader>f :Sleuth<CR>
endif

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

if has('nvim') || !exists('g:EDITOR')
    set completeopt-=preview
    set completeopt+=menuone,noinsert,noselect
    set shortmess+=c
    nnoremap <silent> <leader>lm :MUcompleteAutoToggle<CR>
    let g:mucomplete#enable_auto_at_startup = 1
    packadd! mucomplete

    let g:polyglot_disabled = ['sensible']
    packadd! polyglot
endif

if !has('nvim') && !exists('g:EDITOR')
    set termguicolors
    packadd! catppuccin-vim
    colorscheme catppuccin_frappe
endif

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
