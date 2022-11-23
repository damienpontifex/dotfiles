local M = {}

function M.setup()

  local lsp_config = require'lspconfig'

  -- vim.api.nvim_create_autocmd('LspAttach', {
  --   callback = function(args) 
  --     local client = vim.lsp.get_client_by_id(args.data.client_id)
  --     if client.server_capabilities.hoverProvider then
  --       vim.keymap.set('n', 'K', vim.lsp.buf.hover, { buffer = args.buf })
  --     end
  --   end,
  -- })

  local function on_attach(client, bufnr)
    vim.notify("Attaching LSP client "..client.name.." to buffer "..bufnr)

    -- print(vim.inspect(client.resolved_capabilities))

    local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end
    buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

    local opts = { silent = true, buffer = true }

    --vim.keymap.set('n', 'gD', ':vs<CR>:lua vim.lsp.buf.definition()<CR>', opts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', 'gd'    ,vim.lsp.buf.definition, opts)
    vim.keymap.set('n', '<C-]>', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'gr'    ,vim.lsp.buf.references, opts)
    vim.keymap.set('n', '<F12>' ,vim.lsp.buf.references, opts)
    vim.keymap.set('n', '<F2>'  ,vim.lsp.buf.rename, opts)
    vim.keymap.set('n', 'ca'    ,vim.lsp.buf.code_action, opts)
    -- buf_set_keymap(bufnr, 'n', '<C-k>' ,vim.lsp.buf.signature_help()<CR>', opts)
    vim.keymap.set('n', 'gr'    ,vim.lsp.buf.references, opts)
    vim.keymap.set('n', 'g0'    ,vim.lsp.buf.document_symbol, opts)
    vim.keymap.set('n', 'gW'    ,vim.lsp.buf.workspace_symbol, opts)

    vim.keymap.set('n', '<leader>dn', vim.diagnostic.goto_next, opts)
    vim.keymap.set('n', '<leader>dp', vim.diagnostic.goto_prev, opts)
    vim.keymap.set('n', '<leader>ds', vim.diagnostic.open_float, opts)
    vim.keymap.set('n', '<leader>af', vim.lsp.buf.code_action, opts)
    vim.keymap.set('n', '<leader>kf', vim.lsp.buf.formatting, opts)

    vim.keymap.set("n", "<space>f", vim.lsp.buf.format, opts)
  end

  -- Setup lspconfig.
  local capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())

  -- Use a loop to conveniently both setup defined servers
  -- and map buffer local keybindings when the language server attaches
  local servers = {'gopls', 'tsserver'}
  for _, lsp in ipairs(servers) do
    lsp_config[lsp].setup {
      on_attach = on_attach,
      capabilities = capabilities,
    }
  end
  lsp_config.jsonls.setup{}

  -- python3 -m pip install --upgrade pyright
  lsp_config.pyright.setup{}

  lsp_config.omnisharp.setup{
    cmd = { "dotnet", "/opt/bin/omnisharp/Omnisharp.dll", "--languageserver", "--hostPID", tostring(vim.fn.getpid()), "--verbose" };
    on_attach = on_attach,
    capabilities = capabilities,
    handlers = {
      ["textDocument/definition"] = require('omnisharp_extended').handler,
    },
  }

  lsp_config.rust_analyzer.setup({
    on_attach = on_attach,
    capabilities = capabilities,
    settings = {
      ["rust-analyzer"] = {
        assist = {
          importGranularity = "module",
          importPrefix = "by_self",
        },
        cargo = {
          loadOutDirsFromCheck = true
        },
        procMacro = {
          enable = true
        },
      }
    }
  })

  vim.lsp.set_log_level('debug')

  lsp_config.yamlls.setup{
    capabilities = capabilities,
    settings = {
      yaml = {
        schemas = {
          ["https://raw.githubusercontent.com/microsoft/azure-pipelines-vscode/master/service-schema.json"] = { "azure-pipelines.yml", "azdo/**/*.yml", ".pipelines/**/*.yml" },
          ["https://json.schemastore.org/github-workflow.json"] = ".github/**",
          ["https://raw.githubusercontent.com/dotnet/tye/main/src/schema/tye-schema.json"] = "tye.yaml",
          ["https://raw.githubusercontent.com/SchemaStore/schemastore/master/src/schemas/json/helmfile.json"] = "helmfile.yaml",
          ["https://json.schemastore.org/catalog-info.json"] = "catalog-info.yaml",
          kubernetes = "/*.yaml"
        }
      }
    },
    on_attach = on_attach,
  }

  lsp_config.terraformls.setup{
    cmd = { "terraform-ls", "serve" },
    on_attach = on_attach,
    capabilities = capabilities,
  }

  lsp_config.bicep.setup {
    cmd = { "dotnet", "/usr/local/bin/bicep-langserver/Bicep.LangServer.dll" },
    on_attach = on_attach,
    capabilities = capabilities,
  }

end

function open_lsp_log()
  vim.cmd('!open ' .. vim.lsp.get_log_path())
end

local function update_lsp(lsp_name, cmd)
  local function on_event(job_id, data, event)
    if event == "exit" then
      if data == 0 then
        print("Done updating " .. lsp_name)
      else
        print("Non-zero exit code updating " .. lsp_name .. vim.inspect(data))
      end
    end

    if (event == "stdout" or event == "stderr") then
      print(data[1])
    end
  end
  vim.fn.jobstart(cmd,
  {
    on_stderr = on_event,
    on_stdout = on_event,
    on_exit = on_event,
    stdout_buffered = false,
    stderr_buffered = false,
  })
end

function update_bicep_lsp()
  update_lsp("bicep", [[
    echo "Bicep version:" \
    $(curl --silent https://api.github.com/repos/azure/bicep/releases/latest \
    | jq --raw-output '.name') \
    && (cd $(mktemp -d) \
    && curl --silent --location --remote-name https://github.com/Azure/bicep/releases/latest/download/bicep-langserver.zip \
    && rm -rf /usr/local/bin/bicep-langserver \
    && unzip -q -d /usr/local/bin/bicep-langserver bicep-langserver.zip || true)
  ]])
end

function update_omnisharp_lsp()
  local cmd = [[
    rm -rf /opt/bin/omnisharp/* \
    && mkdir -p /opt/bin/omnisharp \
    && curl --silent --location \
      https://github.com/OmniSharp/omnisharp-roslyn/releases/latest/download/omnisharp-osx-arm64-net6.0.tar.gz \
    | tar xz - -C /opt/bin/omnisharp
  ]]
  update_lsp("omnisharp", cmd)
end

function update_terraform_ls()
  update_lsp("terraform-ls", 'brew upgrade terraform-ls || brew install hashicorp/tap/terraform-ls')
end

function update_typescript_ls()
  update_lsp("typescript-language-server", "npm install --global typescript-language-server typescript")
end

function update_rust_analyzer()
  update_lsp("rust-analyzer", 'brew upgrade rust-analyzer || brew install rust-analyzer')
end

function update_gopls()
  update_lsp("gopls", [[
    GO111MODULE=on go install golang.org/x/tools/gopls@latest
  ]])
end

function update_yaml_ls()
  update_lsp("yaml-language-server", [[
    yarn global add yaml-language-server
  ]])
end

function update_all_lsps()
  update_omnisharp_lsp()
  update_bicep_lsp()
  update_terraform_ls()
  update_typescript_ls()
  update_rust_analyzer()
  update_gopls()
  update_yaml_ls()
end

M.update_lsps = function()
  os.execute 'npm install --global vscode-json-languageserver'
  os.execute 'python3 -m pip install --user -U cmake-language-server'
  os.execute [[python3 -m pip install --user -U 'python-language-server[all]']]
end

return M
