return {
  -- lsp servers
  {
    "williamboman/mason.nvim",
    build = ":MasonUpdate",
    lazy = false,
    opts = {
      ensure_installed = { 
        "rust_analyzer",
        "tsserver",
        "bicep",
        "omnisharp",
        "helm_ls",
        "terraformls",
        "gopls",
      },
      automatic_installation = true,
    },
  },

  {
    "williamboman/mason-lspconfig.nvim",
    lazy = false,
  },
  
  -- lspconfig
  {
    "neovim/nvim-lspconfig",
    -- wants = { "cmp-nvim-lsp" },
    -- event = "VeryLazy",
    lazy = false,
    dependencies = {
      "Hoffs/omnisharp-extended-lsp.nvim",
    },
    config = function()
      local lsp_config = require('lspconfig')

      vim.api.nvim_create_autocmd({ 'LspAttach' }, {
        group = vim.api.nvim_create_augroup('UserLspConfig', {}),
        callback = function(ev)
          -- print(vim.inspect(client.resolved_capabilities))

          vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

          local opts = { buffer = ev.buf }

          vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
          vim.keymap.set('n', 'gD', function()
            require('telescope.builtin').lsp_definitions({ jump_type = 'vsplit' })
          end, opts)
          vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
          vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
          vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
          vim.keymap.set('n', '<C-]>', vim.lsp.buf.definition, opts)
          vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
          vim.keymap.set('n', '<F12>' ,vim.lsp.buf.references, opts)
          vim.keymap.set('n', '<F2>'  ,vim.lsp.buf.rename, opts)
          vim.keymap.set('n', 'ca'    ,vim.lsp.buf.code_action, opts)
          vim.keymap.set('n', 'gr'    ,vim.lsp.buf.references, opts)
          vim.keymap.set('n', 'g0'    ,vim.lsp.buf.document_symbol, opts)
          vim.keymap.set('n', 'gW'    ,vim.lsp.buf.workspace_symbol, opts)

          vim.keymap.set('n', '<leader>dn', vim.diagnostic.goto_next, opts)
          vim.keymap.set('n', '<leader>dp', vim.diagnostic.goto_prev, opts)
          vim.keymap.set('n', '<leader>ds', vim.diagnostic.open_float, opts)
          vim.keymap.set('n', '<leader>af', vim.lsp.buf.code_action, opts)
          vim.keymap.set('n', '<leader>kf', vim.lsp.buf.format, opts)

          vim.keymap.set("n", "<space>f", vim.lsp.buf.format, opts)

          -- https://github.com/OmniSharp/omnisharp-roslyn/issues/2483
          local client = vim.lsp.get_client_by_id(ev.data.client_id)
          local function toSnakeCase(str)
            return string.gsub(str, "%s*[- ]%s*", "_")
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

      -- Setup lspconfig.
      local capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())

      lsp_config.omnisharp.setup({
        capabilities = capabilities,
        cmd = { vim.fn.stdpath "data" .. "/mason/packages/omnisharp/omnisharp" },
        enable_roslyn_analyzers = true,
        organize_imports_on_format = true,
        enable_import_completion = true,
        handlers = {
          ["textDocument/definition"] = require('omnisharp_extended').handler,
        },
      })

      lsp_config.rust_analyzer.setup({
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
              ["https://json.schemastore.org/github-workflow.json"] = ".github/workflows/*",
              ["https://raw.githubusercontent.com/dotnet/tye/main/src/schema/tye-schema.json"] = "tye.yaml",
              ["https://raw.githubusercontent.com/SchemaStore/schemastore/master/src/schemas/json/helmfile.json"] = "helmfile.yaml",
              ["https://json.schemastore.org/catalog-info.json"] = "catalog-info.yaml",
              ["https://raw.githubusercontent.com/microsoft/vscode-dapr/main/assets/schemas/dapr.io/dapr/cli/run-file.json"] = "dapr.yaml",
              ["https://json.schemastore.org/catalog-info.json"] = "catalog-info.yaml",
              kubernetes = "/*.yaml"
            }
          }
        },
      }

      local servers = {'gopls', 'pyright', 'terraformls', 'bicep', 'helm_ls'}
      for _, lsp in ipairs(servers) do
        lsp_config[lsp].setup {
          capabilities = capabilities,
        }
      end

    end
  },

}
