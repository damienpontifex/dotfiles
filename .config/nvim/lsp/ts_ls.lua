--       -- commands = {
--   OrganizeImports = {
--     function()
--       vim.lsp.execute_command({
--         command = '_typescript.organizeImports',
--         arguments = { vim.api.nvim_buf_get_name(0) }
--       })
--     end,
--     description = 'Organize Imports'
--   }
-- },
-- on_attach = function(client, bufnr)
--   vim.api.nvim_create_autocmd('BufWritePre', {
--     group = vim.api.nvim_create_augroup('ts_ls', { clear = false }),
--     buffer = bufnr,
--     callback = function()
--       print('Organizing imports for buffer: ' .. bufnr, vim.inspect(client.commands))
--       client.exec_cmd('OrganizeImports', { bufnr = bufnr })
--     end
--   })
-- end,
-- }

-- Configuration parameters https://github.com/typescript-language-server/typescript-language-server/blob/master/docs/configuration.md
local ts_ls_options = { -- Here as options need to be set for both typescript and javascript separately
  inlayHints = {
    includeInlayEnumMemberValueHints = true,
    includeInlayFunctionLikeReturnTypeHints = true,
    includeInlayFunctionParameterTypeHints = true,
    includeInlayParameterNameHintsWhenArgumentMatchesName = true,
    includeInlayPropertyDeclarationTypeHints = true,
    includeInlayVariableTypeHints = true,
    includeInlayVariableTypeHintsWhenTypeMatchesName = true,
    includeInlayParameterNameHints = 'all', -- 'all' | 'literals' | 'none'
  },
  implementationCodeLens = { enabled = true },
  referencesCodeLens = { enabled = true, showOnAllFunctions = true, },
}
return {
  settings = {
    preferences = {
      importModuleSpecifierPreference = 'non-relative',
      quotePreference = 'single',
    },
    typescript = ts_ls_options,
    javascript = ts_ls_options,
  },
}
