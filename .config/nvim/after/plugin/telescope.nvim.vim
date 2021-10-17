nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>

" nnoremap <C-p> <cmd>lua require("telescope.builtin").find_files({hidden=true, layout_config={prompt_position="top"}})<CR>
" nnoremap <C-p> <cmd>Telescope find_files hidden=true<CR>
nnoremap <C-p> <cmd>Telescope git_files<CR>
nnoremap <C-f> <cmd>Telescope live_grep<CR>

nnoremap <leader>gs <cmd>Telescope git_status<CR>

lua << EOF
local actions = require('telescope.actions')
require('telescope').setup{
  defaults = {
    layout_config = {
      vertical = {
        mirror = true,
      },
    },
    mappings = {
      i = {
        ["<esc>"] = actions.close
      },
    },
  }
}
EOF
