vim.pack.add({
	"https://github.com/mfussenegger/nvim-lint",
})
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
