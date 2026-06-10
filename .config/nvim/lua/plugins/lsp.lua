vim.pack.add({
	"https://github.com/neovim/nvim-lspconfig",
	"https://github.com/mason-org/mason.nvim",
	"https://github.com/mason-org/mason-lspconfig.nvim",
	{ src = "https://github.com/saghen/blink.cmp", version = vim.version.range("1.*") },
	"https://github.com/Kaiser-Yang/blink-cmp-avante",
	-- "https://github.com/j-hui/fidget.nvim",
	"https://github.com/rachartier/tiny-inline-diagnostic.nvim",
	"https://github.com/b0o/schemastore.nvim",
	"https://github.com/rafamadriz/friendly-snippets",
	{ src = "https://github.com/Joakker/lua-json5" },
})

-- tiny-inline-diagnostic.nvim
require("tiny-inline-diagnostic").setup({})

-- blink.cmp (autocompletion)
require("blink.cmp").setup({
	keymap = { preset = "default" },
	appearance = {
		nerd_font_variant = "mono",
	},
	completion = {
		menu = {
			-- Delay before the menu opens. Prevents blink from calling set_cursor
			-- on the floating window during fast typing, which causes the cursor
			-- to jump back in the editing window (Neovim floating window bug).
			auto_show_delay_ms = 100,
		},
	},
	signature = { enabled = true },
	cmdline = {
		completion = {
			menu = { auto_show = true },
		},
	},
})

-- mason + mason-lspconfig
require("mason").setup()
require("mason-lspconfig").setup({
	automatic_enable = true,
	ensure_installed = {
		"bashls",
		"bicep",
		"copilot",
		"docker_compose_language_service",
		"dockerls",
		"gopls",
		"helm_ls",
		"kotlin_lsp",
		"gradle_ls",
		"lua_ls",
		"rust_analyzer",
		"terraformls",
		"ts_ls",
		"yamlls",
		"jsonls",
		"pyright",
	},
})

-- Ensure non-LSP tools are installed via mason-registry
local registry = require("mason-registry")
local tools = {
	-- DAP adapters
	"js-debug-adapter",
	"bash-debug-adapter",
	"netcoredbg",
	"codelldb",
	"debugpy",
	-- Linters & formatters
	"biome",
	"detekt",
	"djlint",
	"eslint_d",
	"prettierd",
	"prettier",
	"shellcheck",
	"csharpier",
	"xmlformatter",
	"stylua",
	"yamlfmt",
}
for _, pkg_name in ipairs(tools) do
	local ok, pkg = pcall(registry.get_package, pkg_name)
	if ok and not pkg:is_installed() then
		pkg:install()
	end
end
