vim.pack.add({
	"https://github.com/nvim-treesitter/nvim-treesitter",
})

local nvim_treesitter = require("nvim-treesitter")
-- Supported languages https://github.com/nvim-treesitter/nvim-treesitter/blob/main/SUPPORTED_LANGUAGES.md
-- nvim_treesitter.install({ "all" })
nvim_treesitter.install({
	"bash",
})

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

vim.api.nvim_create_autocmd("PackChanged", {
	desc = "Handle nvim-treesitter updates",
	group = vim.api.nvim_create_augroup("damienpontifex/nvim-treesitter", { clear = true }),
	callback = function(event)
		if event.data.kind == "update" and event.data.spec.name == "nvim-treesitter" then
			vim.notify("nvim-treesitter updated, running TSUpdate...", vim.log.levels.INFO)
			---@diagnostic disable-next-line: param-type-mismatch
			local ok = pcall(vim.cmd, "TSUpdate")
			if ok then
				vim.notify("TSUpdate completed successfully", vim.log.levels.INFO)
			else
				vim.notify("TSUpdated command failed", vim.log.levels.WARN)
			end
		end
	end,
})
