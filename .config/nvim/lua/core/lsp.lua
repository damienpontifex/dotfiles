vim.diagnostic.config({
  virtual_text = true,
  virtual_lines = true,
  severity_sort = true,
  float = {
    border = 'rounded',
    source = true,
  },
})

vim.api.nvim_create_autocmd({ 'LspAttach' }, {
  group = vim.api.nvim_create_augroup('my.lsp', {}),
  callback = function(args)
    local client = assert(vim.lsp.get_client_by_id(args.data.client_id), 'must have valid client')
    local bufnr = args.buf

    -- Auto format on save
    if client:supports_method('textDocument/formatting', bufnr) then
      vim.api.nvim_create_autocmd('BufWritePre', {
        group = vim.api.nvim_create_augroup('my.lsp', { clear = false }),
        buffer = args.buf,
        callback = function()
          vim.lsp.buf.format({ bufnr = args.buf, id = client.id, timeout_ms = 1000 })
        end
      })
    end

    if client:supports_method('testDocument/foldingRange', bufnr) and vim.fn.exists('*vim.lsp.foldexpr') == 1 then
      vim.wo.foldmethod = 'expr'
      vim.wo.foldexpr = 'v:lua.vim.lsp.foldexpr()'
    end

    if client:supports_method('textDocument/inlayHint', bufnr) then
      vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
    end

    if client:supports_method('textDocument/codeLens', bufnr) then
      vim.lsp.codelens.refresh()
      vim.api.nvim_create_autocmd(
        { 'BufEnter', 'CursorHold', 'InsertLeave' },
        {
          buffer = bufnr,
          callback = vim.lsp.codelens.refresh,
        }
      )
    end

    vim.bo[args.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'
    -- vim.lsp.completion.enable(true, client.id, args.buf, { autotrigger = true })

    local opts = { buffer = args.buf }

    -- vim.keymap.set('i', '<C-Space>', vim.lsp.omnifunc, { desc = 'LSP: Trigger completion', buffer = args.buf })

    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'gD', function()
      require('telescope.builtin').lsp_definitions({ jump_type = 'vsplit' })
    end, opts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', '<C-]>', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
    vim.keymap.set('n', '<F12>', vim.lsp.buf.references, opts)
    vim.keymap.set('n', '<leader>cr', vim.lsp.buf.rename, opts)
    vim.keymap.set('n', '<F2>', vim.lsp.buf.rename, opts)
    vim.keymap.set('n', 'ca', vim.lsp.buf.code_action, opts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
    vim.keymap.set('n', 'g0', vim.lsp.buf.document_symbol, opts)
    vim.keymap.set('n', 'gW', vim.lsp.buf.workspace_symbol, opts)

    vim.keymap.set('n', '<leader>dn', function() vim.diagnostic.jump({ count = 1, float = true }) end, opts)
    vim.keymap.set('n', '<leader>dp', function() vim.diagnostic.jump({ count = -1, float = true }) end, opts)
    vim.keymap.set('n', '<leader>ds', vim.diagnostic.open_float, opts)
    vim.keymap.set('n', '<leader>af', vim.lsp.buf.code_action, opts)
    vim.keymap.set('n', '<leader>kf', vim.lsp.buf.format, opts)

    vim.keymap.set('n', '<leader>f', vim.lsp.buf.format, opts)

    -- https://github.com/OmniSharp/omnisharp-roslyn/issues/2483
    local function toSnakeCase(str)
      return string.gsub(str, '%s*[- ]%s*', '_')
    end

    if client.name == 'omnisharp' then
      local tokenModifiers = client.server_capabilities.semanticTokensProvider.legend.tokenModifiers
      for i, v in ipairs(tokenModifiers) do
        tokenModifiers[i] = toSnakeCase(v)
      end
      local tokenTypes = client.server_capabilities.semanticTokensProvider.legend.tokenTypes
      for i, v in ipairs(tokenTypes) do
        tokenTypes[i] = toSnakeCase(v)
      end
    end
    --
  end,
})
