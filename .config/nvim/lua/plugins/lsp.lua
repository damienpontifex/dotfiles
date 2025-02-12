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
        "lua-language-server",
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
    lazy = false,
    dependencies = {
      "Hoffs/omnisharp-extended-lsp.nvim",
      "saghen/blink.cmp",
      "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
    },
    config = function()
      -- vim.lsp.set_log_level('info')

      local lsp_config = require('lspconfig')

      local capabilities = require('blink.cmp').get_lsp_capabilities()

      local function get_project_rustanalyzer_settings()
        local handle = io.open(vim.fn.resolve(vim.fn.getcwd() .. '/./.rust-analyzer.json'))
        if not handle then
          return {}
        end
        local out = handle:read("*a")
        handle:close()
        local config = vim.json.decode(out)
        if type(config) == "table" then
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
        bicep = true,
        helm_ls = true,
        omnisharp = {
          cmd = { vim.fn.stdpath "data" .. "/mason/packages/omnisharp/omnisharp" },
          enable_roslyn_analyzers = true,
          organize_imports_on_format = true,
          enable_import_completion = true,
          handlers = {
            ["textDocument/definition"] = require('omnisharp_extended').handler,
          },
        },
        rust_analyzer = {
          settings = {
            ["rust-analyzer"] = vim.tbl_deep_extend("force",
              {
                assist = {
                  importGranularity = "module",
                  importPrefix = "by_self",
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
                ["https://raw.githubusercontent.com/microsoft/azure-pipelines-vscode/master/service-schema.json"] = { "azure-pipelines.yml", "azdo/**/*.yml", ".pipelines/**/*.yml" },
                ["https://json.schemastore.org/github-workflow.json"] = ".github/workflows/*",
                ["https://raw.githubusercontent.com/dotnet/tye/main/src/schema/tye-schema.json"] = "tye.yaml",
                ["https://raw.githubusercontent.com/SchemaStore/schemastore/master/src/schemas/json/helmfile.json"] =
                "helmfile.yaml",
                ["https://json.schemastore.org/catalog-info.json"] = "catalog-info.yaml",
                ["https://raw.githubusercontent.com/microsoft/vscode-dapr/main/assets/schemas/dapr.io/dapr/cli/run-file.json"] =
                "dapr.yaml",
                kubernetes = "/*.yaml"
              }
            }
          }
        }
      }

      for name, config in pairs(servers) do
        if config == true then
          config = {}
        end
        config = vim.tbl_deep_extend("force", {}, {
          capabilities = capabilities,
        }, config)

        lsp_config[name].setup(config)
      end

      vim.api.nvim_create_autocmd({ 'LspAttach' }, {
        group = vim.api.nvim_create_augroup('UserLspConfig', {}),
        callback = function(args)
          local client = assert(vim.lsp.get_client_by_id(args.data.client_id), "must have valid client")

          if client.supports_method('textDocument/formatting') then
            -- Format the current buffer on save
            vim.api.nvim_create_autocmd('BufWritePre', {
              buffer = args.buf,
              callback = function()
                vim.lsp.buf.format({ bufnr = args.buf, id = client.id })
              end
            })
          end

          if client.supports_method('testDocument/foldingRange') and vim.fn.exists("*vim.lsp.foldexpr") == 1 then
            vim.wo.foldmethod = 'expr'
            vim.wo.foldexpr = 'v:lua.vim.lsp.foldexpr()'
          end

          vim.bo[args.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

          local opts = { buffer = args.buf }

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

          vim.keymap.set('n', '<leader>dn', vim.diagnostic.goto_next, opts)
          vim.keymap.set('n', '<leader>dp', vim.diagnostic.goto_prev, opts)
          vim.keymap.set('n', '<leader>ds', vim.diagnostic.open_float, opts)
          vim.keymap.set('n', '<leader>af', vim.lsp.buf.code_action, opts)
          vim.keymap.set('n', '<leader>kf', vim.lsp.buf.format, opts)

          vim.keymap.set("n", "<leader>f", vim.lsp.buf.format, opts)

          -- https://github.com/OmniSharp/omnisharp-roslyn/issues/2483
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

      require("lsp_lines").setup()
      vim.diagnostic.config { virtual_text = true, virtual_lines = true }

      vim.keymap.set("", "<leader>l", function()
        local config = vim.diagnostic.config() or {}
        if config.virtual_text then
          vim.diagnostic.config { virtual_text = false, virtual_lines = true }
        else
          vim.diagnostic.config { virtual_text = true, virtual_lines = false }
        end
      end, { desc = "Toggle lsp_lines" })

      vim.diagnostic.config({
        virtual_text = {
          source = "always",
          prefix = "●",
          spacing = 2,
          max_width = 30, -- for a shorter virtual text indicator
        },
        float = {
          source = "always",
          border = "rounded",
        },
      })
    end
  },
}
