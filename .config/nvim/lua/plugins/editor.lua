return {
  -- Render markdown
  {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = { "markdown", "codecompanion" },
  },

  -- Set lualine as statusline
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    opts = {
      options = {
        theme = 'catppuccin-macchiato'
      },
    },
  },

  -- Highlight todo, notes, etc in comments
  {
    'folke/todo-comments.nvim',
    event = 'VimEnter',
    dependencies = { 'nvim-lua/plenary.nvim' },
    opts = { signs = false }
  },

  -- For showing available keymaps
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    keys = {
      {
        "<leader>?",
        function()
          require("which-key").show({ global = false })
        end,
        desc = "Buffer Local Keymaps (which-key)",
      },
    },
  },

  -- Top tab bar to show all buffers
  -- {
  --   'romgrk/barbar.nvim',
  --   event = 'VimEnter',
  --   dependencies = {
  --     -- 'lewis6991/gitsigns.nvim',     -- OPTIONAL: for git status
  --     'nvim-tree/nvim-web-devicons', -- OPTIONAL: for file icons
  --   },
  --   opts = {},
  --   keys = {
  --     { "<Tab>",   ":BufferNext<CR>",     desc = "Next buffer", },
  --     { "<S-Tab>", ":BufferPrevious<CR>", desc = "Previous buffer", },
  --   },
  -- },
}
