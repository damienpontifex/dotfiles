local M = {}

function M.setup()

  local opts = { noremap=true, silent=true }
  vim.api.nvim_set_keymap('n', '<Leader>ff', [[<Cmd>lua require('telescope.builtin').find_files()<CR>]], opts)
  vim.api.nvim_set_keymap('n', '<Leader>fg', [[<Cmd>lua require('telescope.builtin').live_grep()<CR>]], opts)
  vim.api.nvim_set_keymap('n', '<Leader>fb', [[<Cmd>lua require('telescope.builtin').buffers()<CR>]], opts)
  vim.api.nvim_set_keymap('n', '<Leader>fh', [[<Cmd>lua require('telescope.builtin').help_tags()<CR>]], opts)
  vim.api.nvim_set_keymap('n', '<Leader>gs', [[<Cmd>lua require('telescope.builtin').git_status()<CR>]], opts)

  vim.api.nvim_set_keymap('n', '<C-p>', [[<Cmd>lua require('telescope.builtin').git_filenis()<CR>]], opts)
  vim.api.nvim_set_keymap('n', '<C-f>', [[<Cmd>lua require('telescope.builtin').live_grep()<CR>]], opts)

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

end

return M
