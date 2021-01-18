sign define LspDiagnosticsErrorSign text=❗️
sign define LspDiagnosticsWarningSign text=⚠️
sign define LspDiagnosticsInformationSign text=ℹ
sign define LspDiagnosticsHintSign text=👉

command! LspRestart lua require'lsp_setup'.restart_lsp_servers()
command! OpenLspLog execute '!open ' . v:lua.vim.lsp.get_log_path()
command! OpenInFinder execute '!open ' . expand("%:p:h")
command! UpdateLsps lua require'lsp_setup'.update_lsps()
" autocmd CursorHold * lua vim.lsp.util.show_line_diagnostics()
