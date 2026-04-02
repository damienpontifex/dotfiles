vim.pack.add({
	"https://github.com/nvim-treesitter/nvim-treesitter", -- required by tabout
	"https://github.com/L3MON4D3/LuaSnip", -- declared tabout dep, unused (blink.cmp is active)
	"https://github.com/hrsh7th/nvim-cmp", -- declared tabout dep, unused (blink.cmp is active)
	"https://github.com/abecodes/tabout.nvim",
	"https://github.com/windwp/nvim-autopairs",
})

require("tabout").setup({
	tabkey = "<Tab>",
	backwards_tabkey = "<S-Tab>",
	act_as_tab = true,
	act_as_shift_tab = false,
	default_tab = "<C-t>",
	default_shift_tab = "<C-d>",
	enable_backwards = true,
	completion = false,
	tabouts = {
		{ open = "'", close = "'" },
		{ open = '"', close = '"' },
		{ open = "`", close = "`" },
		{ open = "(", close = ")" },
		{ open = "[", close = "]" },
		{ open = "{", close = "}" },
	},
	ignore_beginning = true,
	exclude = {},
})

require("nvim-autopairs").setup({})
