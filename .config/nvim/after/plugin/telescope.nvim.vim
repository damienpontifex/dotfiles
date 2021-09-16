nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>

nnoremap <C-p> <cmd>Telescope find_files<CR>
nnoremap <C-f> <cmd>Telescope live_grep<CR>

nnoremap <leader>gs <cmd>Telescope git_status<CR>

lua << EOF
require('telescope').setup{
  defaults = {
    layout_config = {
      vertical = {
        mirror = true,
      },
    },
  }
}
EOF
