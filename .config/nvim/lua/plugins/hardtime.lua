vim.pack.add({
	"https://github.com/MunifTanjim/nui.nvim",
	"https://github.com/m4xshen/hardtime.nvim",
})

require("hardtime").setup({
	enabled = false, -- Have i learnt anything, test without this for a while
	disable_mouse = false,
})
