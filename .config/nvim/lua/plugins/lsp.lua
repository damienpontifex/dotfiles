return {
  {
    -- Useful status updates for LSP.
    "j-hui/fidget.nvim",
    opts = {},
  },
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

          for _, pkg_name in ipairs { "js-debug-adapter", "bash-debug-adapter", "netcoredbg", "codelldb", } do
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
