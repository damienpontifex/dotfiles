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
    { '<C-f>',      require('telescope.builtin').live_grep,            desc = 'Grep' },
    { '<Leader>fg', require('telescope.builtin').live_grep,            desc = 'Grep' },
    { '<Leader>gf', require('telescope.builtin').git_files,            desc = '[G]it [F]iles' },
    { '<Leader>fb', require('telescope.builtin').buffers,              desc = 'Find buffers' },
    { '<Leader>fc', require('telescope.builtin').commands,             desc = '[F]ind [C]ommands' },
    { '<Leader>fk', require('telescope.builtin').keymaps,              desc = '[F]ind [K]eymaps' },
    { '<Leader>fh', require('telescope.builtin').help_tags,            desc = '[F]ind [H]elp' },
    { '<Leader>gs', require('telescope.builtin').git_status,           desc = '[G]it [S]tatus' },
    { '<C-t>',      require('telescope.builtin').lsp_document_symbols, desc = 'LSP workspace symbols' },
  },
  opts = {
    defaults = {
      hidden = true,
      file_ignore_patterns = { "%.git/", "node_modules/", "%.DS_Store", ".next/", },
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
          -- view selection at top of window
          ['<CR>'] = function(prompt_bufnr)
            require('telescope.actions').select_default(prompt_bufnr)
            vim.cmd('normal! zt')
          end,
          -- ["<esc>"] = require('telescope.actions').close
        },
        n = {
          ['<CR>'] = function(prompt_bufnr)
            require('telescope.actions').select_default(prompt_bufnr)
            vim.cmd('normal! zt')
          end,

        }
      },
    },
  },
}
