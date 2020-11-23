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


" Start recognising file types for syntax highlighting and behaviours
filetype on
filetype plugin on
filetype indent on

" turn on syntax highlighting
syntax on

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

" Allow me to edit the vimrc file easily
nnoremap <leader>ev :vsplit $MYVIMRC<cr>
nnoremap <leader>sv :source $MYVIMRC<cr>

" Shortcuts for NERDTree and TagList
nnoremap <leader>nt :NERDTreeToggle<cr>
nnoremap <leader>tl :TlistToggle<cr>

" NERDTree specific stuff
" from https://github.com/scrooloose/nerdtree/issues/433#issuecomment-92590696
function! NERDTreeHighlightFile(extension, fg, bg, guifg, guibg)
    exec 'autocmd filetype nerdtree highlight ' . a:extension .' ctermbg='. a:bg .' ctermfg='. a:fg .' guibg=' .a:guibg .' guifg='. a:guifg
    exec 'autocmd filetype nerdtree syn match ' . a:extension .' #^\s\+.*'. a:extension .'$#'
endfunction

call NERDTreeHighlightFile('py','green','none','green','#151515')
call NERDTreeHighlightFile('yaml','yellow','none','yellow','#151515')
call NERDTreeHighlightFile('txt','white','none','white','#151515')
call NERDTreeHighlightFile('json','red','none','red','#151515')

" --------------------------------------------------------------------
"  plugins
" --------------------------------------------------------------------
" tpope/vim-fugitive - git inside vim
" tpope/vim-surround - ease work with '' () "" {} and other parenthesis
" tpope/vim-commentary
" ctrlp.vim - fuzzy file finder
" vim-airline - status/tabline for each window.  This will display the mode,
" version contro linfo, filename and read only flag, file type, file encoding
" current position in file.  I definitely want this.
" luochen1990/rainbow - show parenthesis in your code in differnt colours
" making it much easier to read the code.
" szw/vim-g - perform google searches from within Vim
" sheerun/vim-polygot - language pack for Vim

" set up rulers and other editor visual aids
set ruler

"set incremental searching"
set incsearch

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

" syntax and appearance within the editor this is now aligned to PEP8 for
" python development
let python_highlight_all=1
set backspace=indent,eol,start
set number " line numbers on
set relativenumber " see relative numbers to allow me to jump around the file more easily
set numberwidth=4 " set the gutter for the line numbers
set tabstop=4 " sets the width of a tab character
set softtabstop=4 " set the number of spaces removed when deleting a tabtab stop, otherwise you would only delete a single space.
set shiftwidth=4 " set the tab indent when using indentation commands in normal mode to 2 characters, default was 8, which is too much
set textwidth=120
set expandtab " replace tabs with spaces
" set autoindent
set fileformat=unix
" Colorscheme - note pre-requisite - need badwolf.vim file in ~/.vim/color
colorscheme badwolf

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
set foldlevel=99

" Abbreviations
" replace double at with my email address
iabbrev @@ max.thomas@moneydashboard.com 

" Areas to explore and understand more
" from the very interesting talk by Max Cantor
" https://www.youtube.com/watch?v=XA2WjJbmmoM&t=411s
" https://github.com/changemewtf/no_plugins/blob/master/no_plugins.vim

" search down into subfolders
" provides tab-completion for all file-related tasks
set path+=**

" Displayu all matching files when we tab complete
set wildmenu

" Create the tags file (which needs ctags and you may need to install that)
command! MakeTags !ctags -R .

" NOW WE CAN:
" - Use ^] to jump to tag under cursor
" - Use g^] for ambiguous tags
" - Use ^t to jump back up the tag stack

" snippets
nnoremap <leader>html :-1read $HOME/.vim/snippet.html<CR>
