
if !exists(":DeleteAllBuffers")
  " bda to close all buffers
  command DeleteAllBuffers :bufdo bd
  cnoreabbrev bda DeleteAllBuffers
endif

" \q to delete buffer without closing window
map <leader>q :bp<CR>:bd#<CR>

" Section: Global Searching
nnoremap <C-f> :Rg<CR>
" nnoremap <C-f> :vimgrep  **/*<L>

let g:vim_json_syntax_conceal = 0
set conceallevel=0 " Never conceal
