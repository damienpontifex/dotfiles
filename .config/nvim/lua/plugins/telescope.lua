return {
  'nvim-telescope/telescope.nvim',
  config = function()
    require('config.telescope').setup()
  end,
  dependencies = {
    'nvim-lua/popup.nvim',
    'nvim-lua/plenary.nvim',
    'nvim-telescope/telescope-live-grep-raw.nvim',
  },
  opts = {
    defaults = {
      theme = "center",
      sorting_strategy = "ascending",
      layout_config = {
        horizontal = {
          prompt_position = "top",
          preview_width = 0.3,
        },
      },
      mappings = {
        i = {
          -- ["<esc>"] = require('telescope.actions').close
        },
      },
    },
  },
  config = function(_, opts)
    local opts = { noremap = true, silent = true }
    local builtin = require('telescope.builtin')
    local themes = require('telescope.themes')
    vim.keymap.set('n', '<Leader>gf', builtin.git_files, opts)
    vim.keymap.set('n', '<Leader>fg', builtin.live_grep, opts)
    vim.keymap.set('n', '<Leader>fb', builtin.buffers, opts)
    vim.keymap.set('n', '<Leader>fc', builtin.commands, opts)
    vim.keymap.set('n', '<Leader>fh', builtin.help_tags, opts)
    vim.keymap.set('n', '<Leader>gs', builtin.git_status, opts)

    local is_inside_work_tree = {}
    -- git_files if in git directory, otherwise find_files
    vim.keymap.set('n', '<C-p>', function()
      local opts = {} -- define here if you want to define something

      local cwd = vim.fn.getcwd()
      if is_inside_work_tree[cwd] == nil then
        vim.fn.system("git rev-parse --is-inside-work-tree")
        is_inside_work_tree[cwd] = vim.v.shell_error == 0
      end

      if is_inside_work_tree[cwd] then
        builtin.git_files(opts)
      else
        builtin.find_files(opts)
      end
    end, opts)
    -- vim.keymap.set('n', '<C-p>', require('config/telescope').project_files, opts)
    --vim.keymap.set('n', '<C-f>', builtin.live_grep, opts)
    require('telescope').load_extension('live_grep_args')
    vim.keymap.set('n', '<C-f>', require('telescope').extensions.live_grep_args.live_grep_args, opts)

    vim.keymap.set('n', '<C-t>', builtin.lsp_dynamic_workspace_symbols, opts)
    vim.keymap.set('n', 'gD', function()
      builtin.lsp_definitions({ jump_type = 'vsplit' })
    end, opts)
  end,
}
