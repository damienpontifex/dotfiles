local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

return {
  -- https://github.com/microsoft/vscode/tree/main/extensions/json-language-features/server#settings
  capabilities = capabilities,
  settings = {
    json = {
      schemas = require('schemastore').json.schemas(),
      validate = { enable = true },
    },
    format = { enable = true },
    provideFormatter = true,
    trace = { server = 'verbose' },
  },
}
