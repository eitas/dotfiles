" Max Thomas

" Vimrc File
"
" max.thomas@eitas.co.uk
" http://eitas.co.uk

" for working in Linux mint or Debian variant as indicated in the default
" vimrc that comes when you install vim
" This line should not be removed as it ensures that various options are
" properly set to work with the Vim-related packages available in Debian.
runtime ! debian.vim

" For now I do not want any compatibility with Vi, although I think this 
" command may be redundant as it is in my user vimrc file.  see:
" http://stackoverflow.com/questions/5845557/in-a-vimrc-is-set-nocompatible-completely-useless
set nocompatible

" System default for mappings is now the " " character
let mapleader = " "

" get copy and paste working between vim and other programs
" This isn't working at the moment and I need to invest some time to get this
" working and understood.  Surprisingly difficult!
set clipboard^=unnamed,unnamedplus

" recommended vim specific settings, adapted from the default vimrc installed
" in Linux mint
set showcmd
set incsearch

" Set the initial window size by number of lines and columns
" set lines=100 columns=100

" tell vim how to manage splits when splitting windows
set splitbelow
set splitright

" with the use of the airline plugin, the visibility of the default statusline
" is redundant
set laststatus=2
" setting the term colors is, I think redundant and so the below can be removed
" vim is smart enough to figure out the color settings and capabilities itself
set t_Co=256

" turn on syntax highlighting
syntax on

" From https://www.youtube.com/channel/UC8ENHE5xdFSwx71u3fDH5Xw
" make Y act like C and D where it acts on the remainder of the line rather
" than the whole line!
nnoremap Y y$
" when joining lines don't let the cursor move about, just jump back to the
" cursor position where you were
nnoremap J mzJ`z
" Add in undo breakpoints on punctuation.  Doing so allows you to undo
" sensible parts without undoing entire lines or paragraphs
inoremap , ,<c-g>u
inoremap . .<c-g>u

" I am rarely going to work in Octal numbers and therefore want VIM to
" recognise any number, including those with leading zeros (e.g. 007) as decimal
" by doing this I can use things like <C-a> and <C-x> to add and subtract
" from digits including those with leading zeros
set nrformats=

" Set hidden.  I do not want to be prompted when acting on multiple files
" Setting hidden will allow me to move between buffers even when they are
" dirty, without warning.  I can then determine actions when I exit VIM
" The danger here is making lots of changes and not being sure if they 
" should be saved or not!
set hidden

" remove the toolbars, menus and scrollbars, don't need any of that
set guioptions-=m
set guioptions-=T
set guioptions-=r
set guioptions-=L

" Look for the ctags file all the way up the directory structure
set tags=tags;
" --------------------------------------------------------------------
" Key remappings
" --------------------------------------------------------------------
" use jk instead of having to <esc> to get back to normal mode (insert mode)
inoremap jk <esc>
" now disable the <esc> key (insert mode) to force use of jk
inoremap <esc> <nop>
" there is an issue with bracketed pasting in vim where I am seeing [200~ etc
" when pasting disabling xterm-bracketed-paste resolves this
set t_BE=
" easy expansion of the active file directory
" taken from practical vim by drew neil
" the below allows us to type %% on vim's : command-line prompt and then
" automatically expand to the path of the active buffer.  This can be very
" useful for :edit, :write, :saveas, :read etc...
" cnoremap <expr> %% getcmdtype() == ':' ? expand('%:h').'/' : '%%'

" allow me to save  with <crtl>s
nnoremap <C-s> :w<CR>
" <not working> inoremap <C-s> <esc>:w<CR>a

" insert a new line without entering insert mode
nnoremap <leader>o o<esc>
nnoremap <leader>O O<esc>

" Allow me to edit the vimrc file easily
nnoremap <leader>ev :vsplit $MYVIMRC<cr>
nnoremap <leader>sv :source $MYVIMRC<cr>

" --------------------------------------------------------------------
"  plugins
" --------------------------------------------------------------------
" A list of useful plugins
"
" tpope/vim-fugitive - git inside vim
" tpope/vim-surround - ease work with '' () "" {} and other parenthesis
" tpope/vim-commentary
" ctrlp.vim - fuzzy file finder
" vim-airline - status/tabline for each window.  This will display the mode,
" version control info, filename and read only flag, file type, file encoding
" current position in file.  I definitely want this.
" luochen1990/rainbow - show parenthesis in your code in differnt colours
" making it much easier to read the code.
" 
" Possible future plugins to look into
" Working with markdown.
" plasticboy/vim-markdown
" iamcco/markdown-preview.nvim

" ------------------------------------------------
" NERDTree specific stuff
" ------------------------------------------------
" from https://github.com/scrooloose/nerdtree/issues/433#issuecomment-92590696

" Shortcuts for NERDTree and TagList
nnoremap <leader>nt :NERDTreeToggle<cr>
nnoremap <leader>tl :TlistToggle<cr>

function! NERDTreeHighlightFile(extension, fg, bg, guifg, guibg)
    exec 'autocmd filetype nerdtree highlight ' . a:extension .' ctermbg='. a:bg .' ctermfg='. a:fg .' guibg=' .a:guibg .' guifg='. a:guifg
    exec 'autocmd filetype nerdtree syn match ' . a:extension .' #^\s\+.*'. a:extension .'$#'
endfunction

call NERDTreeHighlightFile('py','green','none','green','#151515')
call NERDTreeHighlightFile('yaml','yellow','none','yellow','#151515')
call NERDTreeHighlightFile('txt','white','none','white','#151515')
call NERDTreeHighlightFile('json','red','none','red','#151515')

" manage how tabs and spaces appear when using show invisibles (set list)
set listchars=tab:▸\ ,eol:¬

" ------------------------------------------------
" YouCompleteMe (YCM)
" ------------------------------------------------
nnoremap <leader>gd :YcmCompleter GoToDeclaration<CR>
set rtp+=~/.fzf


" ------------------------------------------------
" Conquer of Completion
" ------------------------------------------------
" adding in details for Tab completion.  See README here
" https://github.com/neoclide/coc.nvim for more details
inoremap <silent><expr> <TAB>
	\ pumvisible() ? "\<C-n>" :
	\ <SID>check_back_space() ? "\<TAB>" :
 	\ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

" ----------------------------------------------
" End of plugin specific mappings
" ------------------------------------------------

" set up rulers and other editor visual aids
set ruler

"highlight whole word when searching
set hlsearch

" ignore case except when the search query contains a capital letter
set ignorecase
set smartcase

" show which mode you are in to save any confusion
set showmode

" set syntax highlighting options.
set background=dark
" Highlight trailing white space
au BufRead, BufNewFile *.py, *.pyw, *.c, *.h match BadWhitespace /\s\+$/

" configure line numbers and how backspace works
set backspace=indent,eol,start
set number " line numbers on
set numberwidth=4 " set the gutter for the line numbers
set relativenumber " moving away from relativenumber.  When using commandline and line number arguments it is easier
" to see the absolute line numbers
set autoindent
set nowrap
set noswapfile
set nobackup
set noerrorbells
set scrolloff=8
set colorcolumn=80
set cmdheight=2
set fileformat=unix
" Colorscheme - note pre-requisite - need badwolf.vim file in ~/.vim/color
colorscheme gruvbox

" for the most part use utf-8, lets be explicit
set encoding=utf-8

" git tags
set tags=tags

set clipboard=unnamedplus

" key bindings
" surround word under cursor in quotes (normal mode)
nnoremap <leader>" viw<esc>a"<esc>hbi"<esc>lel
nnoremap <leader>' viw<esc>a'<esc>hbi'<esc>lel
" disable arrow keys not sure I strictly need these anymore, but better safer than sorry.
inoremap <Up> <nop>
inoremap <Down> <nop>
inoremap <Left> <nop>
inoremap <Right> <nop>
nnoremap <Up> <nop>
nnoremap <Down> <nop>
nnoremap <Left> <nop>
nnoremap <Right> <nop>

" handle split navigations
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

" enable folding
set foldmethod=indent
set nofoldenable
set foldlevel=99

" Areas to explore and understand more
" from the very interesting talk by Max Cantor
" https://www.youtube.com/watch?v=XA2WjJbmmoM&t=411s
" https://github.com/changemewtf/no_plugins/blob/master/no_plugins.vim

" search down into subfolders
" provides tab-completion for all file-related tasks
set path+=**

" Display all matching files when we tab complete
set wildmenu

" Create the tags file (which needs ctags and you may need to install that)
command! MakeTags !ctags -R .

" NOW WE CAN:
" - Use ^] to jump to tag under cursor
" - Use g^] for ambiguous tags
" - Use ^t to jump back up the tag stack

" snippets
" nnoremap <leader>html :-1read $HOME/.vim/vimsnippets/snippet.html<CR>6j3wa
"

" if a file is changed outside of vim, automatically reload it without asking
set autoread
" ------------------------------------------------------------------------
"  autocmd with filetypes
" -----------------------------------------------------------------------
"
if has("autocmd")
    " Start recognising file types for syntax highlighting and behaviours
    filetype on
    filetype plugin on
    filetype indent on
    set smartindent
    
    autocmd FileType html setlocal ts=2 sts=2 sw=2 expandtab textwidth=120
    " set this up to conform to PEP8
    autocmd FileType python setlocal ts=4 sts=4 sw=4 expandtab textwidth=120 
    autocmd FileType css setlocal ts=2 sts=4 sw=2 expandtab text
    autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab 
endif
