vim.pack.add({
	"https://github.com/tpope/vim-fugitive",
	"https://github.com/lewis6991/gitsigns.nvim",
	"https://github.com/sindrets/diffview.nvim",
	"https://github.com/nvim-lua/plenary.nvim",
	"https://github.com/NeogitOrg/neogit",
})

-- gitsigns
require("gitsigns").setup()

-- vim-fugitive
vim.keymap.set("n", "<leader>gB", ":Git blame<CR>", { desc = "Git blame", silent = true, noremap = true })

vim.api.nvim_create_autocmd("FileType", {
	pattern = { "fugitive", "fugitiveblame", "gitcommit", "gitrebase" },
	callback = function()
		vim.keymap.set("n", "<CR>", function()
			local commit = vim.fn.matchstr(vim.fn.getline("."), [[^\s*\zs\w\+]])
			vim.cmd("DiffviewOpen --range=" .. commit)
		end, { buffer = true, silent = true, desc = "Open Diffview for commit/file" })
	end,
})

-- neogit
local neogit = require("neogit")
neogit.setup()

vim.keymap.set("n", "<leader>gs", neogit.open, { desc = "Open Neogit", silent = true, noremap = true })
vim.keymap.set("n", "<leader>gc", function()
	neogit.open({ "commit" })
end, { desc = "Neogit commit", silent = true, noremap = true })
vim.keymap.set("n", "<leader>gp", function()
	neogit.open({ "push" })
end, { desc = "Neogit push", silent = true, noremap = true })
vim.keymap.set("n", "<leader>gl", function()
	neogit.open({ "pull" })
end, { desc = "Neogit pull", silent = true, noremap = true })
vim.keymap.set("n", "<leader>gb", function()
	neogit.open({ "branch" })
end, { desc = "Neogit branch", silent = true, noremap = true })

vim.keymap.set("n", "<leader>gd", ":DiffviewOpen<CR>", { desc = "Open Diffview", silent = true, noremap = true })
vim.keymap.set("n", "<leader>gD", ":DiffviewClose<CR>", { desc = "Close Diffview", silent = true, noremap = true })
