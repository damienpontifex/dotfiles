-- fuzzy finder
return {
	"nvim-telescope/telescope.nvim",
	event = "VimEnter",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons",
		"nvim-telescope/telescope-live-grep-args.nvim",
	},
	config = function()
		local telescope = require("telescope")
		local lga_actions = require("telescope-live-grep-args.actions")
		telescope.setup({
			defaults = {
				hidden = true,
				-- file_ignore_patterns = { "%.git/", "node_modules/", "%.DS_Store", ".next/", "target/" },
				theme = "center",
				sorting_strategy = "ascending",
				layout_config = {
					prompt_position = "top",
					width = 0.99,
					preview_width = 0.5,
				},
				mappings = {
					i = {
						-- view selection at top of window
						["<CR>"] = function(prompt_bufnr)
							require("telescope.actions").select_default(prompt_bufnr)
							vim.cmd("normal! zt")
						end,
						-- https://github.com/nvim-telescope/telescope-live-grep-args.nvim?tab=readme-ov-file#configuration
						-- quote prompt to then be able to pass other rg args separated by space
						-- See https://github.com/BurntSushi/ripgrep/blob/master/GUIDE.md for rg args
						["<C-k>"] = lga_actions.quote_prompt(),
						["<C-i>"] = lga_actions.quote_prompt({ postfix = " --iglob " }),
						-- ["<esc>"] = require('telescope.actions').close
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

		local builtin = require("telescope.builtin")
		vim.keymap.set("n", "<C-p>", function()
			builtin.find_files({ hidden = true, no_ignore = false, file_ignore_patterns = { ".git" } })
		end, { desc = "Find files" })
		vim.keymap.set("n", "<Leader>ff", function()
			builtin.find_files({ hidden = true, no_ignore = true })
		end, { desc = "Find files" })
		-- e.g. `-g*.lua leader` see `rg -h` for options
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
	end,
}
