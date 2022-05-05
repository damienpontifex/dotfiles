local M = {}

function M.setup()
  require'nvim-treesitter.configs'.setup {
    ensure_installed = { "c", "lua", "rust", "go", "html", "c_sharp", "cpp", "python", "yaml", },
    highlight = {
      enabled = true,
    },
  }
end

return M
