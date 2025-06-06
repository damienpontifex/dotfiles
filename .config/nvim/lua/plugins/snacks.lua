return {
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
}
