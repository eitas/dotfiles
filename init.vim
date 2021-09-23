" --------------------------------------------------------------------
" Lets get started, simple general setup
" --------------------------------------------------------------------

let mapleader = " "
colorscheme gruvbox
set number
set numberwidth=4
set relativenumber
set ignorecase
set smartcase
set autoindent
set nowrap
set noswapfile
set nobackup
set noerrorbells
set scrolloff=8
set colorcolumn=80
set cmdheight=2
set fileformat=unix
set encoding=utf-8
set clipboard+=unnamedplus " https://vi.stackexchange.com/questions/84/how-can-i-copy-text-to-the-system-clipboard-from-vim
set path+=** " tab-completion for all file-related tasks

" handle split navigations avoid C-W 
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

" --------------------------------------------------------------------
" Ok, getting a bit more opinionated here
" --------------------------------------------------------------------
" highlight trailing white space
au BufRead, BufNewFile *.py, *.c, *.h match BadWhitespace /\s\+$/

" menu for files
set wildmode=longest,list,full
set wildmenu
" Ignore the following file types
set wildignore+=*.pyc
set wildignore+=*.swp
set wildignore+=*_build/*
set wildignore+=**/node_modules/*
set wildignore+=**/.git/*

" --------------------------------------------------------------------
" Key bindings
" --------------------------------------------------------------------
" INSERT Bindings
" use jk instead of having to <esc> to get back to normal mode (insert mode)
inoremap jk <esc>
" now disable the <esc> key (insert mode) to force use of jk
inoremap <esc> <nop>

" NORMAL bindings
" Allow me to edit the init.vim file easily
nnoremap <leader>ev :vsplit $MYVIMRC<cr>
nnoremap <leader>sv :source $MYVIMRC<cr>

set tabstop=2 shiftwidth=2 expandtab textwidth=120

" Have F3 open help for the word under cursor
map <F3> "zyiw:exe "h ".@z.""<CR>

" keep searches at the centre of the screen
nmap n nzz
nmap N Nzz
nmap * *zz

augroup vimrc-incsearch-highlight
  autocmd!
  autocmd CmdlineEnter /,\? :set hlsearch
  autocmd CmdlineLeave /,\? :set nohlsearch
augroup END

" --------------------------------------------------------------------
" Plugins
" --------------------------------------------------------------------
call plug#begin(stdpath('data') . '/plugged')

" Language Server Protocol
Plug 'neovim/nvim-lspconfig'
" Treesitter - getting more language support
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'JoosepAlviste/nvim-ts-context-commentstring'
" Telescope
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-telescope/telescope-fzy-native.nvim'
" Adding snippet capability
Plug 'SirVer/ultisnips'
" Linting
Plug 'dense-analysis/ale'
" Nerdtree - File viewer / manager
Plug 'preservim/nerdtree'
" Git support
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-rhubarb'
Plug 'airblade/vim-gitgutter'
" Comments
Plug 'tpope/vim-commentary'
" Surround
Plug 'tpope/vim-surround'
" Status line
Plug 'vim-airline/vim-airline'
" Code browsing
Plug 'vim-scripts/taglist.vim'

" Other plugins to consider
" SimpylFold
" coc.nvim - though I think Telescope will cover this
" fzf - again I think telescope will cover this
" typescript-vim but I wonder if there is a LSP for this now


call plug#end()

" With airline have the nice pointy arrows
let g:airline_powerline_fonts = 1

" Tree sitter languages
" TSInstall bash
" TSInstall cmake
" TSInstall css
" TSInstall dockerfile
" TSInstall json
" TSInstall lua
" TSInstall python
" TSInstall regex
" TSInstall rust
" TSInstall typescript
" TSInstall yaml
" --------------------------------------------------------------------
" Research
" --------------------------------------------------------------------
" Navigating code and using CTags
" https://geekdude.github.io/tech/ctags/
" The Clipboard
" https://vi.stackexchange.com/questions/84/how-can-i-copy-text-to-the-system-clipboard-from-vim
" Handling folds within nvim
" ???
" Alternative to NERDTree
" https://github.com/kyazdani42/nvim-tree.lua
" Direct interaction with Github CLI
" https://github.com/pwntester/octo.nvim
" Lua snippets
" https://github.com/L3MON4D3/LuaSnip
" Alternative status line
" https://github.com/hoob3rt/lualine.nvim
" --------------------------------------------------------------------
" Useful links
" --------------------------------------------------------------------
" Max Cantor - avoiding use of plugins (which I have clearly ignored!)
" https://www.youtube.com/watch?v=XA2WjJbmmoM&t=411s
" https://github.com/changemewtf/no_plugins/blob/master/no_plugins.vim

  
