syntax enable
set t_ut= " without this line, weird things happen when using tmux
set noswapfile
set nowrap
set colorcolumn=100

" Enable file type detection
filetype plugin on

" Smaller updatetime for CursorHold & CursorHoldI
set updatetime=300

set number relativenumber " line numbering
set mouse=a " Enable mouse
set clipboard=unnamed " use os clipboard
" Allow unsaved changes in buffers
set hidden

set cursorline
set tabstop=2 " number of visual spaces per TAB
set shiftwidth=2 " number of spaces for each >> or << indent shift
set expandtab " tabs are space
set cindent
" set cursorline " highligh current line
set showmatch " highlight matching [{()}]
" Be smart when using tabs ;)
set smarttab

" Default to fold 1 - rermind me it exists
" zm to fold and zr to unfold
set foldmethod=indent
set foldlevelstart=99

" Insert mode cursor as bar
" let &t_SI = "\e[6 q"
" let &t_EI = "\e[2 q"

set t_Co=256

set sessionoptions=buffers,tabpages,winsize

" Disable beeping and flashing
set noerrorbells visualbell t_vb=

:set inccommand=nosplit " So nvim does highlight and substitution while you type

" incremental search 
set incsearch " search as characters are entered
set ignorecase
set smartcase " Don't ignore case if including case in search
" recursive find/search
set path+=**
set wildmenu " visual autocomplete for command menu

set wildignore+=*/node_modules/*
" set wildignore+=*/bin/*,*/obj/*
let &grepprg='grep -n --exclude-dir={.git,node_modules,bin,obj} $* /dev/null | redraw! | cw'

" More natural split opening
set splitright
set splitbelow

set hlsearch " highlight matches
augroup MyColors
    autocmd!
    " See :h cterm-colors for colours
    autocmd ColorScheme * highlight Search ctermbg=LightBlue ctermfg=Black
augroup END

set backspace=indent,eol,start

" Automatically reload file if changed on disk (if no changes in vim)
set autoread
au CursorHold * checktime

