"
" GENERAL
"

" show commands
set showcmd

" How many lines to remember?
set history=700

" enable filetype plugins
filetype plugin on
filetype indent on

" Turn off vi compatibility
set nocompatible

set smartindent
set autoindent

" load indent file for the current filetype
filetype indent on


" auto reload if file has changed
set autoread

" map leader key for more combinations
let mapleader=","
let g:mapleader=","

" fast saving
nmap <leader>w :w!<cr>

" nohlsearch 
map <F4> :nohl<cr>

" copy current line and paste it down
map <F3> yyp

" :W sudo saves the file
command W w !sudo tee % > /dev/null

"
" Ui
"

" 7 lines from cursor to monitor end
set so=7

set wildmenu

" set current position
set ruler

set cmdheight=2

" abdon buffer on hide
set hid

" highlight search results
set hlsearch

" nice search
set incsearch

" caseinsensitive search
set ignorecase

" relative line numbering
set rnu
set number 

" no redraw then running macros
set lazyredraw

" magic for regex
set magic

" show matching brackets
set showmatch

" how many 10th of seconds to blink when matching brackets
set mat=2

" disable sounds
set noerrorbells
set novisualbell
set t_vb=
set tm=500

" bit margin to the left
set foldcolumn=1


"
" COLORS AND FONTS
"
syntax enable

try
	colorscheme peaksea
catch
endtry

set background=dark

" default encoding
set encoding=utf8

" use unix as default filetime
set ffs=unix,dos,mac

" use spaces instead of tabs
set expandtab
set smarttab

" get normal backspace behavement
set backspace=2
set backspace=indent,eol,start
set whichwrap+=<,>,h,l

" 1 tab == 4 spaces
set shiftwidth=4
set tabstop=4

" linebreak on 500 chars
set lbr
set tw=500

set ai "Auto indent
set si "Smart indent
set wrap "wrap lines

" move between windows
map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l
" move split right
map <C-a> <C-W>r

" remap vim 0 to first non-blank char
map 0 ^

" Map <Space> to / (search) and Ctrl-<Space> to ? (backwards search)
map <space> /
map <c-space> ?

" persistent undo
set undodir=~/.vim/tmp/undo
set undofile

" clang integration
map <leader>f :pyfile ~/.vim/clang-format.py<CR>
imap <leader>f <ESC>:pyfile ~/.vim/clang-format.py<CR>i

" format all buffers ( attention: also formats other file formats when in buffer )
map <leader>fa :bufdo :pyfile ~/.vim/clang-format.py<CR>

" fix cpu intensive scrolling when syntax highlighning on
set nocursorcolumn
set nocursorline
syntax sync minlines=256
set regexpengine=1

" create tags file in current dir
command CreateTagsFile !ctags -R . 
map <F12> :CreateTagsFile<cr>

" navigate to definition
map <leader>sd <C-]>
" show match list
map <leader>sl :tselect<cr>
" jump to next matching tag
map <leader>sn :tnext<cr>

" make shell behave like cmd
set shellcmdflag=-ic
