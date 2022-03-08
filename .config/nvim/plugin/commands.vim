command! Vterm :vs|:term
command! Hterm :sp|:term
" bda to close all buffers
command! DeleteAllBuffers :bufdo bd
cnoreabbrev bda DeleteAllBuffers

command! OpenLspLog execute '!open ' . v:lua.vim.lsp.get_log_path()
command! OpenInFinder execute '!open ' . expand("%:p:h")

