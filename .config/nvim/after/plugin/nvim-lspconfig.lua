vim.api.nvim_exec([[
"   sign define LspDiagnosticsErrorSign text=❗️
"   sign define LspDiagnosticsWarningSign text=⚠️
"   sign define LspDiagnosticsInformationSign text=ℹ
"   sign define LspDiagnosticsHintSign text=👉

  command! OpenLspLog execute '!open ' . v:lua.vim.lsp.get_log_path()
  command! OpenInFinder execute '!open ' . expand("%:p:h")
  command! UpdateLsps lua require'pontifex.lsp_setup'.update_lsps()
  autocmd CursorHold * lua vim.diagnostic.open_float()
]], false)

vim.o.completeopt = 'menuone,noinsert,noselect'
vim.g.completion_matching_strategy_list = {'exact', 'substring', 'fuzzy'}

-- vim.bo.omnifunc = 'v:lua.vim.lsp.omnifunc'

local lsp_config = require'lspconfig'
local lsp_completion = require'completion'

local function on_attach(client, bufnr)
  lsp_completion.on_attach(client, bufnr)

  vim.notify("Attaching LSP client "..client.name.." to buffer "..bufnr)

  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end
  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')
  -- vim.api.nvim_buf_set_option(bufnr, 'completeopt', 'menuone,noinsert,noselect')

  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local opts = { noremap=true, silent=true }
  buf_set_keymap('n', 'gD'    ,':vs<CR>:lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'gd'    ,'<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', '<C-]>' ,'<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'gr'    ,'<cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap('n', 'K'     ,'<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', '<F12>' ,'<cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap('n', '<F2>'  ,'<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  buf_set_keymap('n', 'ca'    ,'<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  -- buf_set_keymap(bufnr, 'n', '<C-k>' ,'<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  buf_set_keymap('n', 'gr'    ,'<cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap('n', 'g0'    ,'<cmd>lua vim.lsp.buf.document_symbol()<CR>', opts)
  buf_set_keymap('n', 'gW'    ,'<cmd>lua vim.lsp.buf.workspace_symbol()<CR>', opts)

  buf_set_keymap('n', '<leader>dn', '<cmd> lua vim.lsp.diagnostic.goto_next()<CR>', opts)
  buf_set_keymap('n', '<leader>dp', '<cmd> lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', '<leader>ds', '<cmd> lua vim.diagnostic.open_float()<CR>', opts)
  buf_set_keymap('n', '<leader>af', '<cmd> lua vim.lsp.buf.code_action()<CR>', opts)
  buf_set_keymap('n', '<leader>kf', '<cmd> lua vim.lsp.buf.formatting()<CR>', opts)

  -- Set some keybinds conditional on server capabilities
  if client.resolved_capabilities.document_formatting then
    -- vim.api.nvim_command[[autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync()]]
    --vim.api.nvim_exec([[
    --  augroup lsp_document_formatting
    --    autocmd! * <buffer>
    --    autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync(nil, 1000)
    --  augroup END
    --]], false)
    buf_set_keymap("n", "<space>f", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
  elseif client.resolved_capabilities.document_range_formatting then
    buf_set_keymap("n", "<space>f", "<cmd>lua vim.lsp.buf.range_formatting()<CR>", opts)
  end

  -- vim.api.nvim_command('autocmd CursorHold * lua vim.lsp.util.show_line_diagnostics()')
end

-- Use a loop to conveniently both setup defined servers
-- and map buffer local keybindings when the language server attaches
local servers = {'gopls', 'omnisharp', 'rust_analyzer', 'tsserver'}
for _, lsp in ipairs(servers) do
  lsp_config[lsp].setup {
    on_attach = on_attach,
  }
end

lsp_config.omnisharp.setup{
  cmd = { "/usr/local/bin/omnisharp/Omnisharp", "--languageserver", "--hostPID", tostring(vim.fn.getpid()) };
}

--vim.lsp.set_log_level('debug')

lsp_config.yamlls.setup{
  settings = {
    yaml = {
      schemas = {
        ["https://raw.githubusercontent.com/microsoft/azure-pipelines-vscode/master/service-schema.json"] = { "azure-pipelines.yml", "azdo/**/*.yml", "pipelines/**/*.yml" };
        ["https://json.schemastore.org/github-workflow"] = { ".github/**/*.yml" };
        kubernetes = "/*.yaml"
      }
    }
  },
  on_attach = on_attach
}

lsp_config.terraformls.setup{
  cmd = { "terraform-ls", "serve" },
  on_attach = on_attach
}

lsp_config.bicep.setup {
  cmd = { "dotnet", "/usr/local/bin/bicep-langserver/Bicep.LangServer.dll" },
  on_attach = on_attach
}

local lsp_setup = {}

function restart_lsp_servers()
  vim.lsp.stop_client(vim.lsp.get_active_clients())
  -- Force LSP for current buffer to start
  vim.cmd('edit')
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
    rm -rf /usr/local/bin/omnisharp \
    && mkdir -p /usr/local/bin/omnisharp \
    && curl --silent --location \
      https://github.com/OmniSharp/omnisharp-roslyn/releases/latest/download/omnisharp-osx.tar.gz \
    | tar xz - -C /usr/local/bin/omnisharp
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
  update_lsp("rust-analyzer", [[
    echo "Rust analyzer version:" \
    $(curl --silent https://api.github.com/repos/rust-analyzer/rust-analyzer/releases/latest \
    | jq --raw-output '.name') \
    && curl --location --silent \
      https://github.com/rust-analyzer/rust-analyzer/releases/latest/download/rust-analyzer-$(uname -m)-apple-darwin.gz \
      | gunzip > /usr/local/bin/rust-analyzer  \
    && chmod +x /usr/local/bin/rust-analyzer
  ]])
end

function update_gopls()
  update_lsp("gopls", [[
    GO111MODULE=on go get golang.org/x/tools/gopls@latest
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

lsp_setup.update_lsps = function()
  os.execute 'npm install --global vscode-json-languageserver'
  os.execute 'python3 -m pip install --user -U cmake-language-server'
  os.execute [[python3 -m pip install --user -U 'python-language-server[all]']]
end

return lsp_setup

