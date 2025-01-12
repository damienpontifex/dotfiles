return {
  -- fuzzy finder
  {
    'nvim-telescope/telescope.nvim',
    event = 'VimEnter',
    version = false, -- telescope did only one release, so use HEAD for now
    dependencies = {
      'nvim-lua/plenary.nvim',
      "nvim-tree/nvim-web-devicons",
    },
    keys = {
      {
        '<C-p>',
        function() require('telescope.builtin').find_files() end,
        desc = 'Find files'
      },
      {
        '<Leader>ff',
        function() require('telescope.builtin').find_files() end,
        desc = 'Find files'
      },
      {
        '<C-f>',
        function() require('telescope.builtin').live_grep() end,
        desc = 'Grep'
      },
      {
        '<Leader>fg',
        function() require('telescope.builtin').live_grep() end,
        desc = 'Grep'
      },
      {
        '<Leader>gf',
        function() require('telescope.builtin').git_files() end,
        desc = '[G]it [F]iles'
      },
      {
        '<Leader>fb',
        function() require('telescope.builtin').buffers() end,
        desc = 'Find buffers'
      },
      {
        '<Leader>fc',
        function() require('telescope.builtin').commands() end,
        desc = '[F]ind [C]ommands'
      },
      {
        '<Leader>fk',
        function() require('telescope.builtin').keymaps() end,
        desc = '[F]ind [K]eymaps'
      },
      {
        '<Leader>fh',
        function() require('telescope.builtin').help_tags() end,
        desc = '[F]ind [H]elp'
      },
      {
        '<Leader>gs',
        function() require('telescope.builtin').git_status() end,
        desc = '[G]it [S]tatus'
      },
      {
        '<C-t>',
        function() require('telescope.builtin').lsp_dynamic_workspace_symbols() end,
        desc = 'LSP workspace symbols'
      },
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
  },
  {
    'Mofiqul/vscode.nvim',
    lazy = false,
    config = function()
      vim.cmd.colorscheme 'vscode'
    end,
  },
  {
    'vim-airline/vim-airline',
    dependencies = {
      'vim-airline/vim-airline-themes',
    },
    config = function()
      vim.g.airline_theme = 'deus'
    end,
  },
  -- Highlight todo, notes, etc in comments
  {
    'folke/todo-comments.nvim',
    event = 'VimEnter',
    dependencies = { 'nvim-lua/plenary.nvim' },
    opts = { signs = false }
  },
}
