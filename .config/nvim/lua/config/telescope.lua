local M = {}

function M.setup()

  local opts = { noremap = true, silent = true }
  local telescope_builtin = require('telescope.builtin')
  vim.keymap.set('n', '<Leader>ff', telescope_builtin.find_files, opts)
  vim.keymap.set('n', '<Leader>fg', telescope_builtin.live_grep, opts)
  vim.keymap.set('n', '<Leader>fb', telescope_builtin.buffers, opts)
  vim.keymap.set('n', '<Leader>fh', telescope_builtin.help_tags, opts)
  vim.keymap.set('n', '<Leader>gs', telescope_builtin.git_status, opts)

  vim.keymap.set('n', '<C-p>', telescope_builtin.git_files, opts)
  vim.keymap.set('n', '<C-f>', telescope_builtin.live_grep, opts)

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
