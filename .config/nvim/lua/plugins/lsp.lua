return {
  -- { -- Autoformat
  --   'stevearc/conform.nvim',
  --   event = { 'BufWritePre' },
  --   cmd = { 'ConformInfo' },
  --   keys = {
  --     {
  --       '<leader>f',
  --       function()
  --         require('conform').format { async = true, lsp_format = 'fallback' }
  --       end,
  --       mode = '',
  --       desc = '[F]ormat buffer',
  --     },
  --   },
  --   opts = {
  --     notify_on_error = false,
  --     format_on_save = function(bufnr)
  --       -- Disable "format_on_save lsp_fallback" for languages that don't
  --       -- have a well standardized coding style. You can add additional
  --       -- languages here or re-enable it for the disabled ones.
  --       local disable_filetypes = { c = true, cpp = true }
  --       if disable_filetypes[vim.bo[bufnr].filetype] then
  --         return nil
  --       else
  --         return {
  --           timeout_ms = 500,
  --           lsp_format = 'fallback',
  --         }
  --       end
  --     end,
  --     formatters_by_ft = {
  --       lua = { 'stylua' },
  --       typescript = function(bufnr)
  --         -- Check if cwd containers prettierrc config file
  --         vim.fn.resolve(vim.fn.getcwd() ..
  --         return { 'biome-check', 'eslint_d', 'prettierd', 'prettier', stop_after_first = true, require_cwd = true }
  --       end,
  --       javascript = { 'biome-check', 'eslint_d', },
  --       typescriptreact = { 'biome-check', 'eslint_d', },
  --       json = { 'biome-check' },
  --       css = { 'biome-check' },
  --       -- Conform can also run multiple formatters sequentially
  --       -- python = { "isort", "black" },
  --       --
  --       -- You can use 'stop_after_first' to run the first available formatter from the list
  --       -- javascript = { "prettierd", "prettier", stop_after_first = true },
  --     },
  --   },
  -- },
  { -- Linting
    'mfussenegger/nvim-lint',
    event = { 'BufReadPre', 'BufNewFile' },
    config = function()
      local lint = require 'lint'
      lint.linters_by_ft = {
        -- markdown = { 'markdownlint' },
        typescript = { 'biomejs' },
      }

      -- To allow other plugins to add linters to require('lint').linters_by_ft,
      -- instead set linters_by_ft like this:
      -- lint.linters_by_ft = lint.linters_by_ft or {}
      -- lint.linters_by_ft['markdown'] = { 'markdownlint' }
      --
      -- However, note that this will enable a set of default linters,
      -- which will cause errors unless these tools are available:
      -- {
      --   clojure = { "clj-kondo" },
      --   dockerfile = { "hadolint" },
      --   inko = { "inko" },
      --   janet = { "janet" },
      --   json = { "jsonlint" },
      --   markdown = { "vale" },
      --   rst = { "vale" },
      --   ruby = { "ruby" },
      --   terraform = { "tflint" },
      --   text = { "vale" }
      -- }
      --
      -- You can disable the default linters by setting their filetypes to nil:
      -- lint.linters_by_ft['clojure'] = nil
      -- lint.linters_by_ft['dockerfile'] = nil
      -- lint.linters_by_ft['inko'] = nil
      -- lint.linters_by_ft['janet'] = nil
      -- lint.linters_by_ft['json'] = nil
      -- lint.linters_by_ft['markdown'] = nil
      -- lint.linters_by_ft['rst'] = nil
      -- lint.linters_by_ft['ruby'] = nil
      -- lint.linters_by_ft['terraform'] = nil
      -- lint.linters_by_ft['text'] = nil

      -- Create autocommand which carries out the actual linting
      -- on the specified events.
      local lint_augroup = vim.api.nvim_create_augroup('lint', { clear = true })
      vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWritePost', 'InsertLeave' }, {
        group = lint_augroup,
        callback = function()
          -- Only run the linter in buffers that you can modify in order to
          -- avoid superfluous noise, notably within the handy LSP pop-ups that
          -- describe the hovered symbol using Markdown.
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
    --@module 'blink.cmp'
    --@type blink.cmp.Config
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
      -- completion = { documentation = { auto_show = false } },
      -- sources = {
      --   default = { 'lsp', 'path', 'snippets', 'buffer' },
      -- },
      -- fuzzy = { implementation = "prefer_rust_with_warning" }
    },
    -- opts_extend = { "sources.default" }
  },
  { -- LSP Configuration
    'williamboman/mason-lspconfig.nvim',
    opts = {
      automatic_enable = true,
      ensure_installed = {
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
          local linters_and_formatters = { "biome", "eslint_d", "prettierd", "prettier", }
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
