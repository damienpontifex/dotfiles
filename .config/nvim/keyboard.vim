xnoremap p "_dP

" Section: Popup Menu 
" When popup menu is visible - Enter key selects highlighted menu item
inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
" Ctrl+Space when in insert mode to launch omni completion for ins-completion
" http://vimdoc.sourceforge.net/htmldoc/insert.html#ins-completion
inoremap <expr> <C-Space> "\<C-x>\<C-o>"
inoremap <expr> <C-@> "\<C-x>\<C-o>"
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
autocmd! CompleteDone * if pumvisible() == 0 | pclose | endif

