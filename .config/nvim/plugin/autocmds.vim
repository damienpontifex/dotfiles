augroup PontifexAutocmds
  autocmd!
  " Automatically reload file if changed on disk (if no changes in vim)
  autocmd CursorHold * checktime

  autocmd FileType xml setlocal equalprg=xmllint\ --format\ --recover\ -\ 2>/dev/null
  autocmd FileType json setlocal equalprg=jq\ .

  autocmd TermOpen term://* startinsert " Start terminal in insert mode

augroup END


