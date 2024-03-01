-- Inspiration https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/plugins/ui.lua
return {
--  {
--    "catppuccin/nvim", 
--    lazy = false,
--    priority = 1000,
--    config = function()
--      vim.cmd.colorscheme 'catppuccin-mocha'
--    end,
--  },
--  {
--    'wojciechkepka/vim-github-dark',
--    lazy = false,
--    priority = 1000,
--    config = function()
--      vim.cmd.colorscheme 'ghdark'
--    end,
--
--  }
  {
    'ellisonleao/gruvbox.nvim',
    lazy = false,
    priority = 1000,
    opts = {
      contrast = 'hard'
    },
    config = function()
      -- vim.g.gruvbox_contrast_dark = 'hard'
      vim.cmd.colorscheme 'gruvbox'
    end,
  },
  {
    'morhetz/gruvbox',
    lazy = false,
    priority = 1000,
    config = function()
      vim.g.gruvbox_contrast_dark = 'hard'
      -- vim.cmd.colorscheme 'gruvbox'
    end,
  },
  {
    'vim-airline/vim-airline',
    dependencies = {
      'vim-airline/vim-airline-themes',
    },
    config = function()
      vim.g.airline_theme = 'gruvbox'
    end,
  },

  -- This is what powers LazyVim's fancy-looking
  -- tabs, which include filetype icons and close buttons.
  {
    "akinsho/bufferline.nvim",
    event = "VeryLazy",
    keys = {
      { "<leader>bp", "<Cmd>BufferLineTogglePin<CR>", desc = "Toggle pin" },
      { "<leader>bP", "<Cmd>BufferLineGroupClose ungrouped<CR>", desc = "Delete non-pinned buffers" },
      { "<leader>bo", "<Cmd>BufferLineCloseOthers<CR>", desc = "Delete other buffers" },
      { "<leader>br", "<Cmd>BufferLineCloseRight<CR>", desc = "Delete buffers to the right" },
      { "<leader>bl", "<Cmd>BufferLineCloseLeft<CR>", desc = "Delete buffers to the left" },
      { "<S-h>", "<cmd>BufferLineCyclePrev<cr>", desc = "Prev buffer" },
      { "<S-l>", "<cmd>BufferLineCycleNext<cr>", desc = "Next buffer" },
      { "[b", "<cmd>BufferLineCyclePrev<cr>", desc = "Prev buffer" },
      { "]b", "<cmd>BufferLineCycleNext<cr>", desc = "Next buffer" },
    },
    opts = {
      options = {
        -- stylua: ignore
        close_command = function(n) vim.api.nvim_buf_delete(n, { force = false }) end,
        -- stylua: ignore
        right_mouse_command = function(n) vim.api.nvim_buf_delete(n, { force = false }) end,
        diagnostics = "nvim_lsp",
        always_show_bufferline = false,
        diagnostics_indicator = function(_, _, diag)
          local icons = {
            Error = " ",
            Warn  = " ",
            Hint  = " ",
            Info  = " ",
          }
          local ret = (diag.error and icons.Error .. diag.error .. " " or "")
          .. (diag.warning and icons.Warn .. diag.warning or "")
          return vim.trim(ret)
        end,
        offsets = {
          {
            filetype = "neo-tree",
            text = "Neo-tree",
            highlight = "Directory",
            text_align = "left",
          },
        },
      },
    },
    config = function(_, opts)
      require("bufferline").setup(opts)
      -- Fix bufferline when restoring a session
      vim.api.nvim_create_autocmd("BufAdd", {
        callback = function()
          vim.schedule(function()
            pcall(nvim_bufferline)
          end)
        end,
      })
    end,
  },
}
