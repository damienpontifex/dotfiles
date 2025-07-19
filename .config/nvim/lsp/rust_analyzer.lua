local function get_project_rustanalyzer_settings()
  local handle = io.open(vim.fn.resolve(vim.fn.getcwd() .. '/rust-analyzer.json'), 'r')
  if not handle then
    return {}
  end
  local out = handle:read('*a')
  handle:close()
  local config = vim.json.decode(out)
  if type(config) == 'table' then
    return config
  end
  return {}
end

-- Configuration settings https://rust-analyzer.github.io/book/configuration.html
local rust_default_settings = {
  assist = {
    importGranularity = 'module',
    importPrefix = 'by_self',
  },
  -- imports = {
  --   preferNoStd = true,
  -- },
  cargo = {
    loadOutDirsFromCheck = true,
  },
  procMacro = { enable = true },
  inlayHints = {
    parameterHints = { type = { enable = true } },
    typeHints = { enable = true },
  },
  lens = {
    enable = true,
    references = { method = { enable = true } },
    parameters = { enable = true },
  },
}

return {
  settings = {
    ['rust-analyzer'] = vim.tbl_deep_extend('force', rust_default_settings, get_project_rustanalyzer_settings()),
  }
}
