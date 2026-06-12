vim.pack.add({
	"https://github.com/nvim-tree/nvim-web-devicons",
	"https://github.com/nvim-lualine/lualine.nvim",
	"https://github.com/romgrk/barbar.nvim",
	"https://github.com/folke/which-key.nvim",
	"https://github.com/nvim-lua/plenary.nvim",
	"https://github.com/norcalli/nvim-colorizer.lua",
	"https://github.com/MeanderingProgrammer/render-markdown.nvim",
	"https://github.com/nvim-mini/mini.nvim",
	"https://github.com/lukas-reineke/indent-blankline.nvim",
	"https://github.com/SmiteshP/nvim-navic",
	"https://github.com/LunarVim/breadcrumbs.nvim",
})

-- render-markdown
require("render-markdown").setup({})

-- indent-blankline
-- Indent guides
require("ibl").setup()

-- Breadcrumbs
-- Uses winbar to show LSP hierarchy
require("nvim-navic").setup({
	lsp = {
		auto_attach = true,
	},
})
require("breadcrumbs").setup()

-- lualine
-- |lualine-usage-and-customization|
require("lualine").setup({
	options = {
		theme = "onedark",
	},
	sections = {
		-- lualine_a = {},
		lualine_b = { "branch", "diff", "diagnostics" },
		lualine_c = {},
	},
	inactive_sections = {
		lualine_c = {},
	},
})

-- todo-comments
-- require("todo-comments").setup({ signs = false })

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
-- https://github.com/nvim-mini/mini.nvim/blob/main/readmes/mini-surround.md
require("mini.surround").setup({})

-- Progress and notifications
-- fidget.nvim (LSP progress)
-- require("fidget").setup({})
-- https://github.com/nvim-mini/mini.nvim/blob/main/readmes/mini-notify.md
require("mini.notify").setup({
	content = {
		-- Only show messages
		format = function(notif)
			return notif.msg
		end,
	},
})

-- barbar
require("barbar").setup({})
vim.keymap.set("n", "<Tab>", ":BufferNext<CR>", { desc = "Next buffer", silent = true })
vim.keymap.set("n", "<S-Tab>", ":BufferPrevious<CR>", { desc = "Previous buffer", silent = true })
