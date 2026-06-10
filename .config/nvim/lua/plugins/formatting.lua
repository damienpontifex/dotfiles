vim.pack.add({
	"https://github.com/stevearc/conform.nvim",
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

-- TODO: Only enable conform for filetypes it's configured to handle
vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"

-- TODO: Filter this keymap for only filetypes conform is configured to handle
vim.keymap.set({ "n", "v" }, "=", function()
	require("conform").format({ async = true, lsp_fallback = true }, function(err)
		if not err then
			if vim.startswith(vim.api.nvim_get_mode().mode:lower(), "v") then
				vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", true)
			end
		end
	end)
end, { desc = "Format buffer" })
