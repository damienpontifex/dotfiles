inoremap <silent><expr> <C-Space> coc#refresh()

" GoTo code navigation.
" nmap <silent> gd <Plug>(coc-definition)
" nmap <silent> gy <Plug>(coc-type-definition)
" nmap <silent> gi <Plug>(coc-implementation)
" nmap <silent> gr <Plug>(coc-references)
nmap <silent> gd :call CocAction('jumpDefinition', 'edit')<CR>
nmap <silent> gD :call CocAction('jumpDefinition', 'vsplit')<CR>
nmap <silent><F2> <Plug>(coc-rename)
nmap <silent><F12> <Plug>(coc-references)
nnoremap <silent> K :call <SID>show_documentation()<CR>
" Apply AutoFix to problem on the current line.
nmap <leader>qf  <Plug>(coc-fix-current)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder.
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

function! s:show_documentation()
  if &filetype == 'vim'
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction
" Default extensions
let g:coc_global_extensions=[
      \ 'coc-omnisharp', 
      \ 'coc-clangd',
      \ 'coc-cmake',
      \ 'coc-css', 
      \ 'coc-html',
      \ 'coc-json', 
      \ 'coc-powershell',
      \ 'coc-python', 
      \ 'coc-rust-analyzer',
      \ 'coc-sourcekit',
      \ 'coc-tsserver', 
      \ 'coc-yaml',
      \ ]

