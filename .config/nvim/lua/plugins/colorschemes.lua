return {
  {
    'Mofiqul/vscode.nvim',
    priority = 1000,
    config = function()
      -- vim.cmd.colorscheme 'vscode'
    end,
  },
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    config = function()
      vim.cmd.colorscheme 'catppuccin'
    end,
  },
  {
    "folke/tokyonight.nvim",
    priority = 1000,
    lazy = false,
    opts = {},
    -- config = function(_, opts)
    --   require('tokyonight').setup(opts)
    --   vim.cmd.colorscheme 'tokyonight-moon'
    -- end,
  },
}
