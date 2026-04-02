vim.pack.add({
	"https://github.com/nvim-lua/plenary.nvim",
	"https://github.com/mikavilpas/yazi.nvim",
})

-- Disable netrw so yazi handles directory navigation
vim.g.loaded_netrwPlugin = 1

require("yazi").setup({
	open_for_directories = false,
	keymaps = {
		show_help = "?",
	},
})

vim.keymap.set({ "n", "v" }, "<leader>-", "<cmd>Yazi<cr>", { desc = "Open yazi at the current file" })
vim.keymap.set({ "n", "v" }, "<C-b>", "<cmd>Yazi<cr>", { desc = "Open yazi at the current file" })
