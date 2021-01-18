syntax enable
set t_ut= " without this line, weird things happen when using tmux

" Enable file type detection
filetype plugin on

set t_Co=256
" " recursive find/search
set path+=**

set wildignore+=*/node_modules/*
" set wildignore+=*/bin/*,*/obj/*
let &grepprg='grep -n --exclude-dir={.git,node_modules,bin,obj} $* /dev/null | redraw! | cw'

" set hlsearch " highlight matches
augroup MyColors
    autocmd!
    " See :h cterm-colors for colours
    autocmd ColorScheme * highlight Search ctermbg=LightBlue ctermfg=Black
augroup END


" Automatically reload file if changed on disk (if no changes in vim)
au CursorHold * checktime

augroup lang
    autocmd!
    autocmd BufNewFile,BufRead *.bicep set filetype=bicep
augroup END

au FileType xml setlocal equalprg=xmllint\ --format\ --recover\ -\ 2>/dev/null
au FileType json setlocal equalprg=jq\ .
