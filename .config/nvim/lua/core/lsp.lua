vim.diagnostic.config({
  virtual_text = true,
  virtual_lines = false,
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

    vim.lsp.set_log_level('INFO')

    -- if client.server_capabilities.executeCommandProvider then
    --   for _, command in pairs(client.server_capabilities.executeCommandProvider.commands) do
    --     -- Strip everything up to the last dot from command
    --     local command_name = command:match('%.([^%.]+)$') or command
    --     print('Adding command: ', command_name, ' for client: ', client.name)
    --     client.commands[command_name] = function()
    --       client.exec_cmd(command, { bufnr = vim.api.nvim_buf_get_name(bufnr) })
    --     end
    --     print('LSP command: ', command)
    --   end
    -- end

    -- print(vim.inspect(client.capabilities))

    -- Auto format on save
    if client.server_capabilities.documentFormattingProvider then
      vim.api.nvim_create_autocmd('BufWritePre', {
        group = vim.api.nvim_create_augroup('my.lsp', { clear = false }),
        buffer = bufnr,
        callback = function()
          vim.lsp.buf.format({ bufnr = bufnr, async = false, id = client.id, timeout_ms = 1000 })
        end
      })
    end

    if client.server_capabilities.colorProvider and vim.lsp.document_color then
      vim.lsp.document_color.enable(true, bufnr)
    end

    if client.server_capabilities.foldingRangeProvider then
      vim.wo.foldmethod = 'expr'
      vim.wo.foldexpr = 'v:lua.vim.lsp.foldexpr()'
    end

    if client.server_capabilities.inlayHintProvider then
      vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
    end

    if client.server_capabilities.codeLensProvider then
      vim.lsp.codelens.refresh()
      vim.api.nvim_create_autocmd({ 'BufEnter', 'CursorHold', 'InsertLeave' },
        {
          group = vim.api.nvim_create_augroup('my.lsp', { clear = false }),
          buffer = bufnr,
          callback = function()
            vim.lsp.codelens.refresh({ bufnr = bufnr })
          end,
        }
      )
    end

    -- Not using in favour of blink.cmp
    -- if client.server_capabilities.completionProvider then
    --   vim.bo[bufnr].omnifunc = 'v:lua.vim.lsp.omnifunc'
    --   vim.lsp.completion.enable(true, client.id, bufnr, { autotrigger = true })
    --   vim.keymap.set('i', '<C-Space>', vim.lsp.completion.get, { desc = 'LSP: Trigger completion', buffer = bufnr })
    -- end

    local opts = { buffer = bufnr }


    vim.keymap.set('n', 'gd', function() vim.lsp.buf.definition({ reuse_win = true }) end, opts)
    vim.keymap.set('n', 'gD', function() vim.lsp.buf.implementation({ reuse_win = true }) end, opts)
    -- vim.keymap.set('n', 'gD', function()
    --   vim.lsp.buf.definition({
    --     on_list = function(list_opts)
    --       print(vim.inspect(list_opts))
    --       if not list_opts.items or #list_opts.items == 0 then
    --         vim.notify('No definition found', vim.log.levels.INFO)
    --         return
    --       elseif #list_opts.items == 1 then
    --         vim.cmd('vsplit')
    --         vim.fn.bufadd(list_opts.items[1].filename)
    --         return
    --       end
    --     end
    --   })
    -- end, vim.tbl_extend('keep', { desc = 'LSP: Definition in split' }, opts))
    -- vim.keymap.set('n', 'gD', '<cmd>vsplit | vim.lsp.buf.definition()<cr>', {
    --   desc = 'LSP: Definition in vertical split',
    --   buffer = bufnr,
    -- })
    -- vim.keymap.set('n', 'gD', function()
    --   require('telescope.builtin').lsp_definitions({ jump_type = 'vsplit' })
    -- end, opts)
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
  end,
})
