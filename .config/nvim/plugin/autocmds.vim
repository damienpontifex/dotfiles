augroup PontifexAutocmds
  autocmd!
  " set hlsearch " highlight matches
  " See :h cterm-colors for colours
  autocmd ColorScheme * highlight Search ctermbg=LightBlue ctermfg=Black

  " Automatically reload file if changed on disk (if no changes in vim)
  autocmd CursorHold * checktime

  autocmd FileType xml setlocal equalprg=xmllint\ --format\ --recover\ -\ 2>/dev/null
  autocmd FileType json setlocal equalprg=jq\ .
 
  " Flash highlight yanked region
  autocmd TextYankPost * silent! lua vim.highlight.on_yank {higroup="Substitute", timeout=200}

  autocmd TermOpen term://* startinsert " Start terminal in insert mode

augroup END


