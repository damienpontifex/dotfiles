return {
	{
		"joshdick/onedark.vim",
		priority = 1000,
		config = function()
			vim.cmd.colorscheme("onedark")
		end,
	},
	{
		"Mofiqul/vscode.nvim",
		priority = 1000,
		config = function()
			-- vim.cmd.colorscheme 'vscode'
		end,
	},
	{
		"folke/tokyonight.nvim",
		lazy = false,
		priority = 1000,
		opts = {},
		config = function()
			-- vim.cmd.colorscheme("tokyonight-night")
		end,
	},
	{
		"projekt0n/github-nvim-theme",
		lazy = false,
		priority = 1000,
		config = function()
			-- vim.cmd.colorscheme("github_dark_dimmed")
		end,
	},
	{
		"nordtheme/vim",
		name = "nordtheme-vim",
		lazy = false,
		priority = 1000,
		config = function()
			-- vim.cmd.colorscheme("nord")
		end,
	},
}
