augroup languageSettings
  autocmd!
  " Allow comments in JSON
  autocmd FileType json syntax match Comment +\/\/.\+$+
  " Disable completion for markdown files
  " autocmd FileType markdown setlocal omnifunc=
  " autocmd FileType markdown setlocal completeopt=
  autocmd BufRead,BufNewFile *.BUILD set filetype=bzl
  autocmd BufRead,BufNewFile *.tf set filetype=terraform
augroup end

