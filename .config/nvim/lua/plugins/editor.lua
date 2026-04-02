vim.pack.add({
	"https://github.com/nvim-tree/nvim-web-devicons",
	"https://github.com/nvim-lualine/lualine.nvim",
	"https://github.com/romgrk/barbar.nvim",
	"https://github.com/folke/which-key.nvim",
	"https://github.com/nvim-lua/plenary.nvim",
	"https://github.com/folke/todo-comments.nvim",
	"https://github.com/norcalli/nvim-colorizer.lua",
	"https://github.com/MeanderingProgrammer/render-markdown.nvim",
	"https://github.com/echasnovski/mini.surround",
})

-- render-markdown
require("render-markdown").setup({})

-- lualine
require("lualine").setup({
	options = {
		theme = "onedark",
	},
	sections = {
		lualine_a = {},
		lualine_b = { "branch", "diff", "diagnostics" },
		lualine_c = {},
	},
	inactive_sections = {
		lualine_c = {},
	},
})

-- todo-comments
require("todo-comments").setup({ signs = false })

-- which-key
require("which-key").setup({})
vim.keymap.set("n", "<leader>?", function()
	require("which-key").show({ global = false })
end, { desc = "Buffer Local Keymaps (which-key)" })

-- nvim-colorizer
require("colorizer").setup({
	"*",
	css = { rgb_fn = true },
})

-- mini.surround
require("mini.surround").setup({})

-- barbar
require("barbar").setup({})
vim.keymap.set("n", "<Tab>", ":BufferNext<CR>", { desc = "Next buffer", silent = true })
vim.keymap.set("n", "<S-Tab>", ":BufferPrevious<CR>", { desc = "Previous buffer", silent = true })
