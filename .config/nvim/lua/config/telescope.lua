local M = {}

function M.setup()

  local opts = { noremap = true, silent = true }
  local builtin = require('telescope.builtin')
  local themes = require('telescope.themes')
  vim.keymap.set('n', '<Leader>gf', builtin.git_files, opts)
  vim.keymap.set('n', '<Leader>fg', builtin.live_grep, opts)
  vim.keymap.set('n', '<Leader>fb', builtin.buffers, opts)
  vim.keymap.set('n', '<Leader>fh', builtin.help_tags, opts)
  vim.keymap.set('n', '<Leader>gs', builtin.git_status, opts)

  vim.keymap.set('n', '<C-p>', function() builtin.find_files(themes.get_dropdown({ previewer = false })) end, opts)

  --vim.keymap.set('n', '<C-f>', builtin.live_grep, opts)
  require('telescope').load_extension('live_grep_args')
  vim.keymap.set('n', '<C-f>', require('telescope').extensions.live_grep_args.live_grep_args, opts)

  vim.keymap.set('n', '<C-t>', builtin.lsp_dynamic_workspace_symbols, opts)
  vim.keymap.set('n', 'gD', function()
    builtin.lsp_definitions({ jump_type = 'vsplit' })
  end, opts)

  local actions = require('telescope.actions')
  require('telescope').setup{
    defaults = {
      mappings = {
        i = {
          ["<esc>"] = actions.close
        },
      },
    }
  }

end

return M
