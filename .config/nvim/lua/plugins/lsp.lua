vim.pack.add({
	"https://github.com/neovim/nvim-lspconfig",
	"https://github.com/mason-org/mason.nvim",
	"https://github.com/mason-org/mason-lspconfig.nvim",
	{ src = "https://github.com/saghen/blink.cmp", version = vim.version.range("1.*") },
	"https://github.com/Kaiser-Yang/blink-cmp-avante",
	"https://github.com/stevearc/conform.nvim",
	"https://github.com/mfussenegger/nvim-lint",
	"https://github.com/j-hui/fidget.nvim",
	"https://github.com/rachartier/tiny-inline-diagnostic.nvim",
	"https://github.com/b0o/schemastore.nvim",
	"https://github.com/rafamadriz/friendly-snippets",
	{ src = "https://github.com/Joakker/lua-json5" },
})

-- conform.nvim (formatting)
require("conform").setup({
	log_level = vim.log.levels.INFO,
	format_on_save = {
		timeout_ms = 1000,
		lsp_format = "fallback",
	},
	formatters = {
		detekt = {
			command = "detekt",
			cwd = function(_, ctx)
				return vim.fs.root(ctx.dirname, { "detekt.yaml", "detekt.yml" })
			end,
			require_cwd = true,
			exit_codes = { 0, 2, 3 },
			stdin = false,
			args = {
				"--auto-correct",
				"--build-upon-default-config",
				"--config",
				vim.fn.expand("detekt.y*ml"),
				"--plugins",
				vim.fn.expand(
					"~/.gradle/caches/modules-2/files-2.1/io.gitlab.arturbosch.detekt/detekt-formatting/**/detekt-formatting-*.jar"
				),
				"--input",
				"$FILENAME",
			},
		},
	},
	formatters_by_ft = {
		cs = { "csharpier" },
		go = { "goimports", "gofmt" },
		html = { "djlint" },
		json = { "jq" },
		kotlin = { "detekt" },
		lua = { "stylua" },
		rust = { "rustfmt" },
		typescript = { "prettierd", "prettier", "eslint", stop_after_first = true },
		xml = { "xmlformatter" },
	},
})

vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"

vim.keymap.set({ "n", "v" }, "=", function()
	require("conform").format({ async = true, lsp_fallback = true }, function(err)
		if not err then
			if vim.startswith(vim.api.nvim_get_mode().mode:lower(), "v") then
				vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", true)
			end
		end
	end)
end, { desc = "Format buffer" })

-- nvim-lint (linting)
local lint = require("lint")

lint.linters.detekt = {
	cmd = "detekt",
	stdin = false,
	append_fname = true,
	args = {
		"--build-upon-default-config",
		"--config",
		vim.fn.expand("detekt.y*ml"),
		"--plugins",
		vim.fn.expand(
			"~/.gradle/caches/modules-2/files-2.1/io.gitlab.arturbosch.detekt/detekt-formatting/**/detekt-formatting-*.jar"
		),
		"--input",
	},
	stream = nil,
	ignore_exitcode = true,
	parser = require("lint.parser").from_errorformat("%f:%l:%c: %m"),
}

lint.linters_by_ft = {
	kotlin = { "detekt" },
	typescript = { "biomejs" },
	sh = { "shellcheck" },
}

local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })
vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
	group = lint_augroup,
	callback = function()
		if vim.bo.modifiable then
			lint.try_lint()
		end
	end,
})

-- fidget.nvim (LSP progress)
require("fidget").setup({})

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
			auto_show_delay_ms = 500,
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
