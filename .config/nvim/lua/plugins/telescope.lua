vim.pack.add({
	"https://github.com/nvim-lua/plenary.nvim",
	"https://github.com/nvim-tree/nvim-web-devicons",
	"https://github.com/nvim-telescope/telescope.nvim",
	"https://github.com/nvim-telescope/telescope-live-grep-args.nvim",
	{ src = "https://github.com/nvim-telescope/telescope-fzf-native.nvim" },
})

local lga_actions = require("telescope-live-grep-args.actions")
local builtin = require("telescope.builtin")

local action_layout = require("telescope.actions.layout")
local actions = require("telescope.actions")
require("telescope").setup({
	pickers = {
		find_files = {
			preview = false,
			layout_config = {
				width = function(_, max_columns, _)
					return math.min(math.max(100, math.floor(max_columns * 0.5)), max_columns - 4)
				end,
			},
		},
	},
	extensions = {
		fzf = {},
		live_grep_args = {},
	},
	defaults = {
		hidden = true,
		theme = "center",
		sorting_strategy = "ascending",
		layout_config = {
			prompt_position = "top",
			width = 0.99,
			preview_width = 0.5,
		},
		-- path_display = { "smart" },
		path_display = { "filename_first" }, -- shorten = { len = 3, exclude = { 1, -1 } } },
		mappings = {
			i = {
				["<CR>"] = function(prompt_bufnr)
					require("telescope.actions").select_default(prompt_bufnr)
					vim.cmd("normal! zt")
				end,
				["<C-k>"] = lga_actions.quote_prompt(),
				["<C-i>"] = lga_actions.quote_prompt({ postfix = " --iglob " }),
				["<M-p>"] = action_layout.toggle_preview,
				["<esc>"] = actions.close,
			},
			n = {
				["<CR>"] = function(prompt_bufnr)
					require("telescope.actions").select_default(prompt_bufnr)
					vim.cmd("normal! zt")
				end,
				["<M-p>"] = action_layout.toggle_preview,
			},
		},
	},
})

vim.keymap.set("n", "<C-p>", function()
	builtin.find_files({
		hidden = true,
		no_ignore = false,
		file_ignore_patterns = { ".git" },
	})
end, { desc = "Find files" })

vim.keymap.set("n", "<Leader>ff", function()
	builtin.find_files({ hidden = true, no_ignore = true })
end, { desc = "Find files (all)" })

vim.keymap.set(
	"n",
	"<C-f>",
	require("telescope").extensions.live_grep_args.live_grep_args,
	{ desc = "Telescope: Grep" }
)
vim.keymap.set("n", "<Leader>fg", builtin.live_grep, { desc = "Grep" })
vim.keymap.set("n", "<Leader>gf", builtin.git_files, { desc = "Telescope: [G]it [F]iles" })
vim.keymap.set("n", "<Leader><space>", builtin.buffers, { desc = "Telescope: Find buffers" })
vim.keymap.set("n", "<Leader>fb", builtin.buffers, { desc = "Telescope: Find buffers" })
vim.keymap.set("n", "<Leader>fc", builtin.commands, { desc = "Telescope: [F]ind [C]ommands" })
vim.keymap.set("n", "<Leader>fk", builtin.keymaps, { desc = "Telescope: [F]ind [K]eymaps" })
vim.keymap.set("n", "<Leader>fh", builtin.help_tags, { desc = "Telescope: [F]ind [H]elp" })
vim.keymap.set("n", "<Leader>gs", builtin.git_status, { desc = "Telescope: [G]it [S]tatus" })
vim.keymap.set("n", "<Leader>gb", builtin.git_branches, { desc = "Telescope: [G]it [B]ranches" })
vim.keymap.set("n", "<Leader>km", builtin.filetypes, { desc = "Telescope: Change file type" })

vim.api.nvim_create_autocmd("PackChanged", {
	desc = "Handle telescope required setup",
	group = vim.api.nvim_create_augroup("damienpontifex/telescope", { clear = true }),
	callback = function(event)
		if
			(event.data.kind == "update" or event.data.kind == "install")
			and event.data.spec.name == "telescope-fzf-native"
		then
			vim.notify("telescope-fzf-native updated, running TSUpdate...", vim.log.levels.INFO)
			vim.system({ "make", "-C", event.data.path }, {
				on_stdout = function(_, data)
					if data then
						print(data)
					end
				end,
				on_stderr = function(_, data)
					if data then
						print("ERR:", data)
					end
				end,
				on_exit = function(_, code)
					if code == 0 then
						vim.notify("telescope-fzf-native.nvim built successfully!", vim.log.levels.INFO)
					else
						vim.notify("Failed to build telescope-fzf-native.nvim", vim.log.levels.ERROR)
					end
				end,
			})
		end
	end,
})
