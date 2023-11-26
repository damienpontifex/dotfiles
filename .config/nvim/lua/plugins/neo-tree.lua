return {
  "nvim-neo-tree/neo-tree.nvim",
  event = 'VeryLazy',
  keys = {
    { "<C-b>", "<cmd>Neotree toggle reveal<CR>", desc = "Toggle" }
  },
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
    "MunifTanjim/nui.nvim",
    -- "3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
  },
  config = function() 
      vim.keymap.set('n', '<C-b>', ':Neotree toggle reveal<CR>', { noremap = true, silent = true })
  end,
}
