return {
  -- {
  --   "folke/noice.nvim",
  --   event = "VeryLazy",
  --   opts = {
  --     -- add any options here
  --   },
  --   dependencies = {
  --     "MunifTanjim/nui.nvim",
  --   }
  -- },
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    ---@type snacks.Config
    opts = {
      -- bigfile = { enabled = true },
      -- dashboard = { enabled = true },
      explorer = {
        enabled = true,
      },
      -- indent = { enabled = true },
      -- input = { enabled = true },
      picker = {
        enabled = true,
        hidden = true,
        ignored = true,
        excluded = { 'node_modules', '.git', '.cache', '.DS_Store' },
      },
      -- notifier = { enabled = true },
      -- quickfile = { enabled = true },
      -- scope = { enabled = true },
      -- scroll = { enabled = true },
      -- statuscolumn = { enabled = true },
      -- words = { enabled = true },
    },
    keys = {
      { '<C-b>', function() Snacks.explorer() end, desc = 'Toggle Snacks Explorer' },
      -- { '<C-f>', '<cmd>SnacksTogglePicker<cr>', desc = 'Toggle Snacks Picker' },
      -- { '<C-s>', '<cmd>SnacksToggleScope<cr>', desc = 'Toggle Snacks Scope' },
      -- { '<C-n>', '<cmd>SnacksToggleNotifier<cr>', desc = 'Toggle Snacks Notifier' },
      -- { '<C-q>', '<cmd>SnacksQuickFile<cr>', desc = 'Snacks Quick File' },
    },
  },
  -- {
  --   "nvim-neo-tree/neo-tree.nvim",
  --   branch = "v3.x",
  --   dependencies = {
  --     "nvim-lua/plenary.nvim",
  --     "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
  --     "MunifTanjim/nui.nvim",
  --     -- {"3rd/image.nvim", opts = {}}, -- Optional image support in preview window: See `# Preview Mode` for more information
  --   },
  --   lazy = false, -- neo-tree will lazily load itself
  --   keys = {
  --     { '<C-b>', '<cmd>Neotree toggle<cr>', desc = 'Toggle NeoTree' },
  --   },
  --   opts = {
  --     filesystem = {
  --       filtered_items = {
  --         hide_dotfiles = false,
  --       },
  --       follow_current_file = {
  --         enabled = true,
  --       }
  --     }
  --   },
  -- },
  -- Set lualine as statusline
  -- See `:help lualine.txt`
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    opts = {
      options = {
        icons_enabled = true,
        theme = 'onedark',
        component_separator = '|',
        section_separators = '',
      },
      sections = {
        lualine_a = { 'buffers' },
        lualine_c = {},
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
}
