nnoremap <C-b> :NERDTreeToggle<CR> " Ctrl + b to toggle nerdtree and focus on current buffer
let NERDTreeShowHidden=1
let NERDTreeRespectWildIgnore=1
" Open NERDTree when vim startups with no files specified
" autocmd StdinReadPre * let s:std_in=1
"autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
let NERDTreeIgnore = ['.git/', '__pycache__', '.ipynb_checkpoints', 'bin/', 'obj']

" Sync nerdtree with current buffer
" autocmd BufEnter * if &modifiable | NERDTreeFind | wincmd p | endif
