return {
  { -- Linting
    'mfussenegger/nvim-lint',
    event = { 'BufReadPre', 'BufNewFile' },
    config = function()
      local lint = require 'lint'
      lint.linters_by_ft = {
        -- markdown = { 'markdownlint' },
        typescript = { 'biomejs' },
        sh = { 'shellcheck' },
      }

      local lint_augroup = vim.api.nvim_create_augroup('lint', { clear = true })
      vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWritePost', 'InsertLeave' }, {
        group = lint_augroup,
        callback = function()
          if vim.bo.modifiable then
            lint.try_lint()
          end
        end,
      })
    end,
  },
  { -- Useful status updates for LSP.
    "j-hui/fidget.nvim",
    opts = {},
  },
  { -- Autocompletion
    'saghen/blink.cmp',
    event = 'VimEnter',
    dependencies = { 'rafamadriz/friendly-snippets' },
    version = '1.*',
    opts = {
      keymap = { preset = 'default' },
      appearance = {
        nerd_font_variant = 'mono'
      },
      signature = { enabled = true },
      cmdline = {
        completion = {
          menu = { auto_show = true, },
        },
      },
    },
  },
  { -- LSP Configuration
    'williamboman/mason-lspconfig.nvim',
    opts = {
      automatic_enable = true,
      ensure_installed = {
        'bashls',
        'bicep',
        'docker_compose_language_service',
        'dockerls',
        'gopls',
        'helm_ls',
        'lua_ls',
        'omnisharp',
        'rust_analyzer',
        'terraformls',
        'ts_ls',
        'yamlls',
        'jsonls',
        'pyright',
      },
    },
    lazy = false,
    dependencies = {
      {
        'williamboman/mason.nvim',
        opts = {},
        config = function(_, opts)
          require('mason').setup(opts)

          -- Ensure that other tools, apart from LSP servers, are installed.
          local registry = require("mason-registry")

          local dap_servers = { "js-debug-adapter", "bash-debug-adapter", "netcoredbg", "codelldb", "debugpy", }
          local linters_and_formatters = { "biome", "eslint_d", "prettierd", "prettier", "shellcheck", }
          for _, pkg_name in ipairs(vim.tbl_deep_extend('force', dap_servers, linters_and_formatters)) do
            local ok, pkg = pcall(registry.get_package, pkg_name)
            if ok then
              if not pkg:is_installed() then
                pkg:install()
              end
            end
          end
        end,
      },
      -- see `set runtimepath?` and nvim-lspconfig is on runtimepath, so lsp folder within that is automatically included in config setup
      'neovim/nvim-lspconfig',
    },
  },
  'Hoffs/omnisharp-extended-lsp.nvim',
  'b0o/schemastore.nvim',
}
