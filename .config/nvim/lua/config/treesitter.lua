local M = {}

function M.setup()
  require'nvim-treesitter.configs'.setup {
    ensure_installed = "maintained",
    highlight = {
      enabled = true,
    },
  }
end

return M
