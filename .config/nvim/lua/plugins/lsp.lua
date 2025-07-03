return {
  {
    'saghen/blink.cmp',
    dependencies = { 'rafamadriz/friendly-snippets' },
    version = '1.*',
    --@module 'blink.cmp'
    --@type blink.cmp.Config
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
        'bicep',
        'gopls',
        'helm_ls',
        'lua_ls',
        'omnisharp',
        'rust_analyzer',
        'terraformls',
        'ts_ls',
        'typescript-language-server',
        'yamlls',
      },
    },
    lazy = false,
    dependencies = {
      { 'williamboman/mason.nvim', opts = {}, },
      {
        -- see `set runtimepath?` and nvim-lspconfig is on runtimepath, so lsp folder within that is automatically included in config setup
        'neovim/nvim-lspconfig',
        dependencies = {
          'Hoffs/omnisharp-extended-lsp.nvim',
          'saghen/blink.cmp',
        },
      },
    },
    config = function()
      -- For list of available servers
      -- :h lspconfig-all
      local servers = {
        lua_ls = {
          settings = {
            Lua = {
              workspace = { library = { vim.env.VIMRUNTIME, } }
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
        },
      }
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
      local function get_project_rustanalyzer_settings()
        local handle = io.open(vim.fn.resolve(vim.fn.resolve(vim.fn.getcwd() .. '/rust-analyzer.json')), 'r')
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
        imports = {
          preferNoStd = true,
        },
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
      servers.rust_analyzer = {
        settings = {
          ['rust-analyzer'] = vim.tbl_deep_extend('force', rust_default_settings, get_project_rustanalyzer_settings()),
        }
      }

      servers.ts_ls = {
        settings = {
          preferences = {
            importModuleSpecifierPreference = 'non-relative',
            quotePreference = 'single',
          },
          typescript = ts_ls_options,
          javascript = ts_ls_options,
        },
      }
      -- commands = {
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

      for name, config in pairs(servers) do
        if config == true then
          config = {}
        end
        -- config.capabilities = require('blink.cmp').get_lsp_capabilities(config.capabilities)

        vim.lsp.config(name, config)
        vim.lsp.enable(name)
      end
    end
  },
}
