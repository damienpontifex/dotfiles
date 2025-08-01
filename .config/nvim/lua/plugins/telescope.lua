-- fuzzy finder
return {
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
      function()
        -- require('telescope.builtin').git_files()
          require('telescope.builtin').find_files({ hidden = true, no_ignore = true })
      end,
      desc = 'Find files'
    },
    {
      '<Leader>ff',
        function() require('telescope.builtin').find_files({ hidden = true, no_ignore = true }) end,
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
      hidden = true,
      file_ignore_patterns = { "%.git/" },
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
}
