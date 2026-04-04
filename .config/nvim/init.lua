if vim.fn.has("nvim-0.12") ~= 1 then
	vim.notify("This config requires Neovim >= 0.12", vim.log.levels.ERROR)
	return
end

vim.g.mapleader = " "
vim.g.maplocalleader = " "

--  For more options, you can see `:help option-list`
vim.opt.number = true
vim.opt.relativenumber = true

require("config.options")
require("winbar")

-- Enable the new experimental command-line features.
require("vim._core.ui2").enable({ msg = { target = "cmd" } })

require("plugins")
require("core.lsp")

require("config.autocmds")
require("config.keymaps")
require("config.user_commands")
