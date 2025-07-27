return {
  {
    'Mofiqul/vscode.nvim',
    lazy = false,
    config = function()
      --vim.cmd.colorscheme 'vscode'
    end,
  },
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
  },
  {
    'rebelot/kanagawa.nvim',
    lazy = false,
    opts = {
      transparent = true,
      overrides = function(_colors)
        return {
          ["@markup.link.url.markdown_inline"] = { link = "Special" },      -- (url)
          ["@markup.link.label.markdown_inline"] = { link = "WarningMsg" }, -- [label]
          ["@markup.italic.markdown_inline"] = { link = "Exception" },      -- *italic*
          ["@markup.raw.markdown_inline"] = { link = "String" },            -- `code`
          ["@markup.list.markdown"] = { link = "Function" },                -- + list
          ["@markup.quote.markdown"] = { link = "Error" },                  -- > blockcode
          ["@markup.list.checked.markdown"] = { link = "WarningMsg" }       -- - [X] checked list item
        }
      end
    },
    config = function(_, opts)
      require('kanagawa').setup(opts)
      vim.cmd.colorscheme 'kanagawa'
    end,
  },
}
