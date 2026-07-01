vim.pack.add({
	"https://github.com/nvim-treesitter/nvim-treesitter",
	"https://github.com/nvim-treesitter/nvim-treesitter-context",
})

-- Sticky scroll/context locking
require("treesitter-context").setup({
	mode = "topline",
})

local nvim_treesitter = require("nvim-treesitter")
-- Supported languages https://github.com/nvim-treesitter/nvim-treesitter/blob/main/SUPPORTED_LANGUAGES.md
-- nvim_treesitter.install({ "all" })
nvim_treesitter.install({
	"bash",
	"c",
	"c_sharp",
	"dockerfile",
	"editorconfig",
	"git_config",
	"git_rebase",
	"gitattributes",
	"gitcommit",
	"gitignore",
	"go",
	"gomod",
	"gomod",
	"gotmpl",
	"graphql",
	"html",
	"java",
	"javascript",
	"jq",
	"json",
	"json5",
	"jsonnet",
	"kotlin",
	"lua",
	"markdown",
	"make",
	"nginx",
	"nix",
	"python",
	"rust",
	"sql",
	"terraform",
	"tmux",
	"typescript",
	"vim",
	"xml",
	"yaml",
	"zsh",
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
		-- Indentation: only use treesitter indent where an indents query exists,
		-- otherwise fall back to autoindent so `o`/`O` don't drop to column 0.
		local lang = vim.treesitter.language.get_lang(vim.bo.filetype)
		if lang and vim.treesitter.query.get(lang, "indents") then
			print("Using treesitter indentation")
			vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
		else
			print("Using nvim indentation")
			vim.bo.indentexpr = ""
			vim.bo.autoindent = true
		end
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
