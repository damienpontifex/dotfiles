return {
	{
		"lewis6991/gitsigns.nvim",
		event = "VimEnter",
	},
	{
		"NeogitOrg/neogit",
		event = "VimEnter",
		dependencies = {
			"nvim-lua/plenary.nvim", -- required
			"sindrets/diffview.nvim", -- optional - Diff integration

			-- Only one of these is needed.
			"nvim-telescope/telescope.nvim", -- optional
			-- "ibhagwan/fzf-lua",              -- optional
			-- "nvim-mini/mini.pick",           -- optional
			-- "folke/snacks.nvim",             -- optional
		},
		config = function(_, opts)
			local neogit = require("neogit")
			neogit.setup(opts)

			vim.keymap.set("n", "<leader>gs", neogit.open, { desc = "Open Neogit", silent = true, noremap = true })
			vim.keymap.set("n", "<leader>gc", function()
				neogit.open({ "commit" })
			end, { desc = "Open Neogit", silent = true, noremap = true })
			vim.keymap.set("n", "<leader>gp", function()
				neogit.open({ "push" })
			end, { desc = "Neogit push", silent = true, noremap = true })
			vim.keymap.set("n", "<leader>gl", function()
				neogit.open({ "pull" })
			end, { desc = "Neogit pull", silent = true, noremap = true })
			vim.keymap.set("n", "<leader>gb", function()
				neogit.open({ "branch" })
			end, { desc = "Neogit branch", silent = true, noremap = true })
			vim.keymap.set("n", "<leader>gB", function()
				neogit.open({ "blame" })
			end, { desc = "Neogit blame", silent = true, noremap = true })
		end,
	},
}
