vim.pack.add({
	-- "https://github.com/joshdick/onedark.vim",
	"https://github.com/olimorris/onedarkpro.nvim",
	"https://github.com/Mofiqul/vscode.nvim",
	"https://github.com/folke/tokyonight.nvim",
	"https://github.com/projekt0n/github-nvim-theme",
	{ src = "https://github.com/nordtheme/vim", name = "nordtheme-vim" },
})

vim.cmd.colorscheme("onedark")

-- Use `:highlight` to see current values
-- `:highlight <group-name>` to view a single group

-- TODO: Source these colours so they match tmux ones I'm using
-- NOTE: asdf
-- FIXME: asdf
vim.api.nvim_set_hl(0, "Normal", { bg = "#21252b" })

-- Make comments stand out
-- see |highlight-groups| or |lsp-highlight|
vim.api.nvim_set_hl(0, "Comment", { fg = "#e5c07b", italic = true })
vim.api.nvim_set_hl(0, "LspInlayHint", { fg = "DarkGray", bg = "none" })
vim.api.nvim_set_hl(0, "LspCodeLens", { link = "LspInlayHint" })
vim.api.nvim_set_hl(0, "LspCodeLensSeparator", { link = "LspInlayHint" })
-- For lsp inline completion hint
vim.api.nvim_set_hl(0, "ComplHint", { link = "LspInlayHint" })

vim.api.nvim_set_hl(
	0,
	"TodoComment",
	{ bg = vim.api.nvim_get_hl(0, { name = "DiagnosticHint" }).fg, fg = "white", bold = true }
)
vim.api.nvim_set_hl(
	0,
	"FixmeComment",
	{ bg = vim.api.nvim_get_hl(0, { name = "DiagnosticError" }).fg, fg = "white", bold = true }
)
vim.api.nvim_set_hl(
	0,
	"NoteComment",
	{ bg = vim.api.nvim_get_hl(0, { name = "DiagnosticHint" }).fg, fg = "white", bold = true }
)

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
	group = vim.api.nvim_create_augroup("damienpontifex/colours", { clear = true }),
	pattern = "*",
	callback = function()
		vim.fn.matchadd("TodoComment", "TODO:")
		vim.fn.matchadd("FixmeComment", "FIXME:")
		vim.fn.matchadd("NoteComment", "NOTE:")
	end,
})
