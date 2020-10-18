" Cancel default behaviour of d, D, c, C to put the text they delete in 
" the default register.
nnoremap d "_d
vnoremap d "_d
nnoremap D "_D
vnoremap D "_D
nnoremap c "_c
vnoremap c "_c
nnoremap C "_C
vnoremap C "_C

xnoremap p "_dP

" Auto format document
nnoremap F gg=G''<CR>
nnoremap <Tab> :bnext<CR>
nnoremap <S-Tab> :bprevious<CR>

" Use arrow keys to resize windows
nnoremap <Up> :resize +2<CR>
nnoremap <Down> :resize -2<CR>
nnoremap <Left> :vertical resize +2<CR>
nnoremap <Right> :vertical resize -2<CR>

" Esc to got to normal mode in terminal
:tnoremap <Esc> <C-\><C-n>

"make < > shifts keep selection
vnoremap < <gv
vnoremap > >gv

" Split navigation using Ctrl+{hjkl}
noremap <C-J> <C-W><C-J>
noremap <C-K> <C-W><C-K>
noremap <C-L> <C-W><C-L>
noremap <C-H> <C-W><C-H>

" Section: Moving around
" Move cursor by display lines when wrapping
noremap  <buffer> <silent> k gk
noremap  <buffer> <silent> j gj
noremap  <buffer> <silent> 0 g0
noremap  <buffer> <silent> $ g$
" Navigate by display lines, even when they wrap
noremap j gj
noremap k gk

" Mappings to move lines with alt+{j,k} in normal, insert, visual modes
" Symbols are the real character generated on macOS when pressing Alt+key
nnoremap ∆ :m .+1<CR>==
nnoremap <M-j> :m .+1<CR>==
nnoremap ˚ :m .-2<CR>==
nnoremap <M-k> :m .-2<CR>==

inoremap ∆ <Esc>:m .+1<CR>==gi
inoremap ˚ <Esc>:m .-2<CR>==gi
vnoremap ∆ :m '>+1<CR>gv=gv
vnoremap <M-j> :m '>+1<CR>gv=gv
vnoremap ˚ :m '<-2<CR>gv=gv
vnoremap <M-k> :m '<-2<CR>gv=gv

" Clear search highlights with double esc
nnoremap <esc><esc> :silent! nohls<cr>

" Section: Popup Menu 
" set completeopt=longest,menuone,preview
set completeopt=noinsert,menuone,noselect
" When popup menu is visible - Enter key selects highlighted menu item
inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
" Ctrl+Space when in insert mode to launch omni completion for ins-completion
" http://vimdoc.sourceforge.net/htmldoc/insert.html#ins-completion
inoremap <expr> <C-Space> "\<C-x>\<C-o>"
inoremap <expr> <C-@> "\<C-x>\<C-o>"
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
autocmd! CompleteDone * if pumvisible() == 0 | pclose | endif

