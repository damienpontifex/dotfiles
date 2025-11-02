return {
	{
		"github/copilot.vim",
		event = "VimEnter",
		init = function()
			vim.api.nvim_set_keymap(
				"i",
				"<M-CR>",
				'copilot#Accept("<CR>")',
				{ expr = true, noremap = true, silent = true }
			)
			vim.g.copilot_no_tab_map = true
			vim.g.copilot_workspace_folders = { vim.fn.getcwd() }
			-- Only accept one line at a time
			-- vim.keymap.set('i', '<Tab>', 'copilot#AcceptLine()', { expr = true, replace_keycodes = false, })
		end,
	},
	-- OpenCode AI coding assistant
	{
		"NickvanDyke/opencode.nvim",
		event = "VimEnter",
		dependencies = {
			-- Recommended for `ask()` and `select()`.
			-- Required for default `toggle()` implementation.
			{ "folke/snacks.nvim", opts = { input = {}, picker = {}, terminal = {} } },
		},
		config = function()
			vim.g.opencode_opts = {
				-- Your configuration, if any — see `lua/opencode/config.lua`, or "goto definition".
			}

			-- Required for `opts.auto_reload`.
			vim.o.autoread = true

			local opencode = require("opencode")

			vim.keymap.set("n", "<leader>ot", opencode.toggle, { desc = "[O]pencode [T]oggle" })

			vim.keymap.set({ "n", "x" }, "<leader>oa", function()
				-- Should it be @this:
				opencode.ask("@cursor: ", { submit = true })
			end, { desc = "[O]pencode [A]sk" })

			vim.keymap.set({ "n", "x" }, "<leader>oe", function()
				opencode.ask("Explain @cursor and its context", { submit = true })
			end, { desc = "[O]pencode [E]xplain" })

			vim.keymap.set({ "n", "x" }, "<C-x>", opencode.select, { desc = "Execute opencode action…" })

			vim.keymap.set({ "n", "x" }, "ga", function()
				opencode.prompt("@this")
			end, { desc = "Add to opencode" })

			vim.keymap.set("n", "<S-C-u>", function()
				opencode.command("messages_half_page_up")
			end, { desc = "opencode half page up" })

			vim.keymap.set("n", "<S-C-d>", function()
				opencode.command("messages_half_page_down")
			end, { desc = "opencode half page down" })
		end,
	},
}
