if vim.fn.has("nvim-0.12") ~= 1 then
	vim.notify("This config requires Neovim >= 0.12", vim.log.levels.ERROR)
	return
end

vim.g.mapleader = " "
vim.g.maplocalleader = " "

require("config.options")

-- Enable the new experimental command-line features.
require("vim._core.ui2").enable({ msg = { target = "cmd" } })

require("plugins")
require("config.lsp")

require("config.autocmds")
require("config.keymaps")
require("config.user_commands")
