return {
	{
		"tpope/vim-fugitive",
		event = "VimEnter",
		config = function()
			vim.keymap.set("n", "<leader>gB", ":Git blame<CR>", { desc = "Git blame", silent = true, noremap = true })

			-- Open Diffview from Fugitive buffers
			vim.api.nvim_create_autocmd("FileType", {
				pattern = { "fugitive", "fugitiveblame", "gitcommit", "gitrebase" }, -- Apply to relevant fugitive buffers
				callback = function()
					-- Map <CR> to open Diffview in a new tab for the file/commit under the cursor
					vim.keymap.set("n", "<CR>", function()
						-- This command uses the fugitive utility to get the object under the cursor and
						-- then opens a Diffview for that specific commit/file
						local commit = vim.fn.matchstr(vim.fn.getline("."), [[^\s*\zs\w\+]])
						vim.cmd("DiffviewOpen --range=" .. commit)
					end, { buffer = true, silent = true, desc = "Open Diffview for commit/file" })

					-- Optional: unmap the default 'o' and 'S' keys if you want a consistent <CR> experience
					-- vim.keymap.set("n", "o", "<CR>", { buffer = true, silent = true })
					-- vim.keymap.set("n", "S", "<CR>", { buffer = true, silent = true })
				end,
			})
		end,
	},
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

			vim.keymap.set(
				"n",
				"<leader>gd",
				":DiffviewOpen<CR>",
				{ desc = "Open Diffview", silent = true, noremap = true }
			)

			vim.keymap.set(
				"n",
				"<leader>gD",
				":DiffviewClose<CR>",
				{ desc = "Close Diffview", silent = true, noremap = true }
			)
		end,
	},
}
