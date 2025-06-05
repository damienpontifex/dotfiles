return {
  {
    'saghen/blink.cmp',
    dependencies = { 'rafamadriz/friendly-snippets' },
    version = '1.*',
    opts = {
      keymap = { preset = 'default' },
      appearance = {
        nerd_font_variant = 'mono'
      },
      signature = { enabled = true },
      -- completion = { documentation = { auto_show = false } },
      -- sources = {
      --   default = { 'lsp', 'path', 'snippets', 'buffer' },
      -- },
      -- fuzzy = { implementation = "prefer_rust_with_warning" }
    },
    -- opts_extend = { "sources.default" }
  },
  {
    'williamboman/mason-lspconfig.nvim',
    opts = {
      automatic_enable = true,
      ensure_installed = {
        'rust_analyzer',
        'ts_ls',
        'bicep',
        'omnisharp',
        'helm_ls',
        'terraformls',
        'gopls',
        'lua_ls',
      },
    },
    lazy = false,
    dependencies = {
      {
        'williamboman/mason.nvim',
        opts = {}
      },
      {
        'neovim/nvim-lspconfig',
        lazy = false,
        dependencies = {
          'Hoffs/omnisharp-extended-lsp.nvim',
          'saghen/blink.cmp',
        },
        config = function()
          -- vim.lsp.set_log_level('info')

          local lsp_config = require('lspconfig')

          -- local capabilities = require('blink.cmp').get_lsp_capabilities()

          local function get_project_rustanalyzer_settings()
            local handle = io.open(vim.fn.resolve(vim.fn.getcwd() .. '/./.rust-analyzer.json'))
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

          -- For list of available servers
          -- :h lspconfig-all
          local servers = {
            lua_ls = {
              settings = {
                Lua = {
                  workspace = {
                    library = {
                      vim.env.VIMRUNTIME,
                    }
                  }
                }
              }
            },
            gopls = true,
            pyright = true,
            terraformls = true,
            bicep = {
              cmd = { vim.fn.stdpath('data') .. '/mason/packages/bicep-lsp/bicep-lsp' },
            },
            helm_ls = true,
            omnisharp = {
              cmd = { vim.fn.stdpath('data') .. '/mason/packages/omnisharp/omnisharp' },
              enable_roslyn_analyzers = true,
              organize_imports_on_format = true,
              enable_import_completion = true,
              handlers = {
                ['textDocument/definition'] = require('omnisharp_extended').handler,
              },
            },
            rust_analyzer = {
              settings = {
                ['rust-analyzer'] = vim.tbl_deep_extend('force',
                  {
                    assist = {
                      importGranularity = 'module',
                      importPrefix = 'by_self',
                    },
                    cargo = {
                      loadOutDirsFromCheck = true,
                    },
                    procMacro = {
                      enable = true
                    },
                  },
                  get_project_rustanalyzer_settings()
                )
              }
            },
            yamlls = {
              settings = {
                yaml = {
                  schemas = {
                    ['https://raw.githubusercontent.com/microsoft/azure-pipelines-vscode/master/service-schema.json'] = { 'azure-pipelines.yml', 'azdo/**/*.yml', '.pipelines/**/*.yml' },
                    ['https://json.schemastore.org/github-workflow.json'] = '.github/workflows/*',
                    ['https://raw.githubusercontent.com/dotnet/tye/main/src/schema/tye-schema.json'] = 'tye.yaml',
                    ['https://raw.githubusercontent.com/SchemaStore/schemastore/master/src/schemas/json/helmfile.json'] =
                    'helmfile.yaml',
                    ['https://json.schemastore.org/catalog-info.json'] = 'catalog-info.yaml',
                    ['https://raw.githubusercontent.com/microsoft/vscode-dapr/main/assets/schemas/dapr.io/dapr/cli/run-file.json'] =
                    'dapr.yaml',
                    kubernetes = '/*.yaml'
                  }
                }
              }
            }
          }

          local capabilities = require('blink.cmp').get_lsp_capabilities()
          for name, config in pairs(servers) do
            if config == true then
              config = {}
            end

            config = vim.tbl_deep_extend('force', {}, {
              capabilities = capabilities,
            }, config)

            lsp_config[name].setup(config)
          end
        end
      },
    }
  }
}
