" inoremap <C-Space> <C-x><C-o>
" inoremap <C-@> <C-Space>

" Add keybindings for LSP
" nnoremap <silent> gD    :vs<CR>:lua vim.lsp.buf.definition()<CR>
" nnoremap <silent> gd    <cmd>lua vim.lsp.buf.definition()<CR>
" nnoremap <silent> <C-]> <cmd>lua vim.lsp.buf.definition()<CR>
" nnoremap <silent> gr    <cmd>lua vim.lsp.buf.references()<CR>
" nnoremap <silent> K     <cmd>lua vim.lsp.buf.hover()<CR>
" nnoremap <silent> <F12> <cmd>lua vim.lsp.buf.references()<CR>
" nnoremap <silent> <F2>  <cmd>lua vim.lsp.buf.rename()<CR>
" nnoremap <silent> ca    <cmd>lua vim.lsp.buf.code_action()<CR>
" inoremap <silent> <C-k> <cmd>lua vim.lsp.buf.signature_help()<CR>
" nnoremap <silent> gr    <cmd>lua vim.lsp.buf.references()<CR>
" nnoremap <silent> g0    <cmd>lua vim.lsp.buf.document_symbol()<CR>
" nnoremap <silent> gW    <cmd>lua vim.lsp.buf.workspace_symbol()<CR>

set completeopt=menuone,noinsert,noselect
let g:completion_matching_strategy_list = ['exact', 'substring', 'fuzzy']

lua require'lsp_setup'

sign define LspDiagnosticsErrorSign text=❗️
sign define LspDiagnosticsWarningSign text=⚠️
sign define LspDiagnosticsInformationSign text=ℹ
sign define LspDiagnosticsHintSign text=👉


" set omnifunc=v:lua.vim.lsp.omnifunc
" autocmd BufWritePre Filetype rust lua vim.lsp.buf.formatting_sync(nil, 1000)

command! LspRestart lua require'lsp_setup'.restart_lsp_servers()

command! OpenLspLog execute '!open ' . v:lua.vim.lsp.get_log_path()

command! OpenInFinder execute '!open ' . expand("%:p:h")

command! UpdateLsps lua require'lsp_setup'.update_lsps()
