vim.o.completeopt = 'menuone,noinsert,noselect'
vim.g.completion_matching_strategy_list = {'exact', 'substring', 'fuzzy'}

vim.bo.omnifunc = 'v:lua.vim.lsp.omnifunc'

local buf_set_keymap = vim.api.nvim_buf_set_keymap

local lsp_config = require'lspconfig'
local lsp_status = require'lsp-status'
lsp_status.register_progress()
lsp_status.config({
  status_symbol = '',
  indicator_errors = '❗️',
  indicator_warnings = '⚠️',
  indicator_info = 'ℹ',
  indicator_hint = '👉',
  indicator_ok = '✔️',
  spinner_frames = { '⣾', '⣽', '⣻', '⢿', '⡿', '⣟', '⣯', '⣷' },
})

local function on_attach(client, bufnr)
  lsp_status.on_attach(client, bufnr)
  require'completion'.on_attach(client, bufnr)

  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
  -- vim.api.nvim_buf_set_option(bufnr, 'completeopt', 'menuone,noinsert,noselect')

  local opts = { noremap=true, silent=true }
  buf_set_keymap(bufnr, 'n', 'gD'    ,':vs<CR>:lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap(bufnr, 'n', 'gd'    ,'<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap(bufnr, 'n', '<C-]>' ,'<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap(bufnr, 'n', 'gr'    ,'<cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap(bufnr, 'n', 'K'     ,'<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap(bufnr, 'n', '<F12>' ,'<cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap(bufnr, 'n', '<F2>'  ,'<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  buf_set_keymap(bufnr, 'n', 'ca'    ,'<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  -- buf_set_keymap(bufnr, 'n', '<C-k>' ,'<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  buf_set_keymap(bufnr, 'n', 'gr'    ,'<cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap(bufnr, 'n', 'g0'    ,'<cmd>lua vim.lsp.buf.document_symbol()<CR>', opts)
  buf_set_keymap(bufnr, 'n', 'gW'    ,'<cmd>lua vim.lsp.buf.workspace_symbol()<CR>', opts)

  -- vim.api.nvim_command('autocmd CursorHold * lua vim.lsp.util.show_line_diagnostics()')
end

local function capabilities()
  lsp_status.capabilities()
end

-- local servers = {'gopls', 'rust_analyzer', 'sumneko_lua', 'tsserver'}
-- for _, lsp in ipairs(servers) do
--   lspconfig[lsp].setup {
--     on_attach = on_attach,
--   }
-- end

-- vim.lsp.set_log_level('debug')

lsp_config.tsserver.setup{
  on_attach = on_attach
}

lsp_config.jsonls.setup{
  on_attach = on_attach
}

lsp_config.pyls.setup{}
--  lsp_config.pyls_ms.setup{
--    init_options = {
--      interpreter = {
--        properties = {
--          InterpreterPath = "/usr/local/bin/python3",
--          Version = "3.x"
--        }
--      }
--    }
--  }

lsp_config.rust_analyzer.setup{
  on_attach = on_attach,
  settings = {
    rust_analyzer = {
      cargoFeatures = {
        loadOutDirsFromCheck = true;
      }
    }
  }
}

lsp_config.yamlls.setup{
  init_options = {
    ["yaml.schemas"] = {
      ["https://raw.githubusercontent.com/microsoft/azure-pipelines-vscode/master/service-schema.json"] = { "azure-pipelines.yml", "azdo/**/*.yml", "pipelines/**/*.yml" };
      ["https://raw.githubusercontent.com/SchemaStore/schemastore/master/src/schemas/json/github-workflow.json"] = { ".github/**/*.yml" };
      ["kubernetes"] = { "*.yaml" }
    }
  },
  on_attach = on_attach
}

lsp_config.cmake.setup{
  on_attach = on_attach
}

lsp_config.terraformls.setup{
  cmd = { "terraform-ls", "serve" },
  on_attach = on_attach
}

lsp_config.omnisharp.setup{
  on_attach = on_attach
}

lsp_config.gopls.setup{
  on_attach = on_attach
}

-- Override hover winhighlight.
local method = 'textDocument/hover'
local hover = vim.lsp.callbacks[method]
vim.lsp.callbacks[method] = function (_, method, result)
   hover(_, method, result)

   for _, winnr in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
     if pcall(function ()
       vim.api.nvim_win_get_var(winnr, 'textDocument/hover')
     end) then
       vim.api.nvim_win_set_option(winnr, 'winhighlight', 'Normal:Visual,NormalNC:Visual')
       break
     else
       -- Not a hover window.
     end
   end
end

local configs = require 'lspconfig/configs'
local lsputil = require 'lspconfig/util'
configs.bicep = {
  default_config = {
    cmd = { "dotnet", "/usr/local/bin/bicep-langserver/Bicep.LangServer.dll" };
    filetypes = { "bicep" };
    root_dir = lsputil.root_pattern(".git");
  };
}

lsp_config.bicep.setup {
  on_attach = on_attach
}

local lsp_setup = {}

lsp_setup.restart_lsp_servers = function()
  vim.lsp.stop_client(vim.lsp.get_active_clients())
  -- Force LSP for current buffer to start
  vim.cmd('edit')
end

lsp_setup.open_lsp_log = function()
  vim.cmd('!open ' .. vim.lsp.get_log_path())
end

lsp_setup.update_lsps = function()
  os.execute 'brew upgrade terraform-ls || brew install hashicorp/tap/terraform-ls'
  os.execute 'npm install --global vscode-json-languageserver'
  os.execute 'npm install --global typescript-language-server typescript'
  os.execute 'python3 -m pip install --user -U cmake-language-server'
  os.execute [[python3 -m pip install --user -U 'python-language-server[all]']]
  os.execute 'GO111MODULE=on go get golang.org/x/tools/gopls@latest'
  os.execute 'curl -L https://github.com/rust-analyzer/rust-analyzer/releases/latest/download/rust-analyzer-mac -o /usr/local/bin/rust-analyzer && chmod +x /usr/local/bin/rust-analyzer'
  os.execute [[(cd $(mktemp -d) \
    && curl -fLO https://github.com/Azure/bicep/releases/latest/download/bicep-langserver.zip \
    && rm -rf /usr/local/bin/bicep-langserver \
    && unzip -d /usr/local/bin/bicep-langserver bicep-langserver.zip)
  ]]
end

return lsp_setup
