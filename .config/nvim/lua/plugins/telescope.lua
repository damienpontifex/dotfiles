vim.pack.add({
	"https://github.com/nvim-lua/plenary.nvim",
	"https://github.com/nvim-tree/nvim-web-devicons",
	"https://github.com/nvim-telescope/telescope.nvim",
	"https://github.com/nvim-telescope/telescope-live-grep-args.nvim",
})

local telescope = require("telescope")
local lga_actions = require("telescope-live-grep-args.actions")
local builtin = require("telescope.builtin")

telescope.setup({
	defaults = {
		hidden = true,
		theme = "center",
		sorting_strategy = "ascending",
		layout_config = {
			prompt_position = "top",
			width = 0.99,
			preview_width = 0.5,
		},
		mappings = {
			i = {
				["<CR>"] = function(prompt_bufnr)
					require("telescope.actions").select_default(prompt_bufnr)
					vim.cmd("normal! zt")
				end,
				["<C-k>"] = lga_actions.quote_prompt(),
				["<C-i>"] = lga_actions.quote_prompt({ postfix = " --iglob " }),
			},
			n = {
				["<CR>"] = function(prompt_bufnr)
					require("telescope.actions").select_default(prompt_bufnr)
					vim.cmd("normal! zt")
				end,
			},
		},
	},
})

telescope.load_extension("live_grep_args")

vim.keymap.set("n", "<C-p>", function()
	builtin.find_files({ hidden = true, no_ignore = false, file_ignore_patterns = { ".git" } })
end, { desc = "Find files" })
vim.keymap.set("n", "<Leader>ff", function()
	builtin.find_files({ hidden = true, no_ignore = true })
end, { desc = "Find files (all)" })
vim.keymap.set("n", "<C-f>", telescope.extensions.live_grep_args.live_grep_args, { desc = "Grep" })
vim.keymap.set("n", "<Leader>fg", builtin.live_grep, { desc = "Grep" })
vim.keymap.set("n", "<Leader>gf", builtin.git_files, { desc = "[G]it [F]iles" })
vim.keymap.set("n", "<Leader><space>", builtin.buffers, { desc = "Find buffers" })
vim.keymap.set("n", "<Leader>fb", builtin.buffers, { desc = "Find buffers" })
vim.keymap.set("n", "<Leader>fc", builtin.commands, { desc = "[F]ind [C]ommands" })
vim.keymap.set("n", "<Leader>fk", builtin.keymaps, { desc = "[F]ind [K]eymaps" })
vim.keymap.set("n", "<Leader>fh", builtin.help_tags, { desc = "[F]ind [H]elp" })
vim.keymap.set("n", "<Leader>gs", builtin.git_status, { desc = "[G]it [S]tatus" })
vim.keymap.set("n", "<Leader>gb", builtin.git_branches, { desc = "[G]it [B]ranches" })
vim.keymap.set("n", "<Leader>km", builtin.filetypes, { desc = "Change file type" })
