vim.pack.add({
	"https://github.com/joshdick/onedark.vim",
	"https://github.com/Mofiqul/vscode.nvim",
	"https://github.com/folke/tokyonight.nvim",
	"https://github.com/projekt0n/github-nvim-theme",
	{ src = "https://github.com/nordtheme/vim", name = "nordtheme-vim" },
})

vim.cmd.colorscheme("onedark")

-- Make comments stand out
-- see |highlight-groups| or |lsp-highlight|
vim.api.nvim_set_hl(0, "Comment", { fg = "#e5c07b", italic = true })
vim.api.nvim_set_hl(0, "LspInlayHint", { fg = "DarkGray", bg = "none" })
vim.api.nvim_set_hl(0, "LspCodeLens", { link = "LspInlayHint" })
vim.api.nvim_set_hl(0, "LspCodeLensSeparator", { link = "LspInlayHint" })
-- For lsp inline completion hint
vim.api.nvim_set_hl(0, "ComplHint", { link = "LspInlayHint" })

vim.api.nvim_set_hl(0, "TodoComment", { bg = vim.api.nvim_get_hl(0, { name = "DiagnosticInfo" }).fg })
vim.api.nvim_set_hl(0, "FixmeComment", { link = "DiagnosticError" })
vim.api.nvim_set_hl(0, "NoteComment", { link = "DiagnosticHint" })

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
	pattern = "*",
	callback = function()
		vim.fn.matchadd("TodoComment", "TODO:")
		vim.fn.matchadd("FixmeComment", "FIXME:")
		vim.fn.matchadd("NoteComment", "NOTE:")
	end,
})
