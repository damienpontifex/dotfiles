vim.pack.add({
	{
		src = "https://github.com/nvim-neo-tree/neo-tree.nvim",
		version = vim.version.range("3"),
	},
	-- dependencies of neo-tree
	"https://github.com/nvim-lua/plenary.nvim",
	"https://github.com/MunifTanjim/nui.nvim",
	"https://github.com/nvim-tree/nvim-web-devicons",
})

require("neo-tree").setup({
	filesystem = {
		follow_current_file = {
			enabled = true,
			leave_dirs_open = false,
		},
	},
})

vim.keymap.set("n", "<leader>e", "<cmd>Neotree reveal toggle<CR>", { silent = true, desc = "Neotree" })

vim.api.nvim_create_autocmd("VimEnter", {
	desc = "Open Neo-tree on startup if no buffers or files are open",
	callback = function()
		-- Get arguments passed to Neovim
		local argv = vim.fn.argv()

		-- Check if Neovim was started with a file or directory
		if #argv > 0 then
			return
		end

		-- Check if the current buffer is empty and unnamed
		local buf_name = vim.api.nvim_buf_get_name(0)
		local buf_ft = vim.bo.filetype

		if buf_name == "" and buf_ft == "" then
			vim.cmd("Neotree show")
		end
	end,
})
