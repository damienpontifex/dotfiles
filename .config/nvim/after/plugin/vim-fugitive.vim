"nnoremap <leader>gs :Git<CR>
nnoremap <leader>gc :Git commit<CR>
nnoremap <leader>gp :Git pull<CR>

"function! ToggleGStatus()
"    if buflisted(bufname('.git/index'))
"        bd .git/index
"    else
"        Git
"        :15wincmd_
"    endif
"endfunction
"command! ToggleGStatus :call ToggleGStatus()
"nnoremap <C-g> :ToggleGStatus<CR>
