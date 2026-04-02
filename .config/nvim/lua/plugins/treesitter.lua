vim.pack.add({
	"https://github.com/nvim-treesitter/nvim-treesitter",
})

local nvim_treesitter = require("nvim-treesitter")
-- Supported languages https://github.com/nvim-treesitter/nvim-treesitter/blob/main/SUPPORTED_LANGUAGES.md
-- nvim_treesitter.install({ "all" })
-- require("nvim-treesitter").install({
-- "bash",
-- })

vim.api.nvim_create_autocmd("FileType", {
	pattern = nvim_treesitter.get_available(),
	group = vim.api.nvim_create_augroup("damienpontifex/treesitter", { clear = true }),
	callback = function()
		-- Highlighting
		vim.treesitter.start()
		-- Folds
		vim.wo[0][0].foldexpr = "v:lua.vim.treesitter.foldexpr()"
		vim.wo[0][0].foldmethod = "expr"
		-- Indentation
		vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
	end,
})
