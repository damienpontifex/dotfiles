vim.pack.add({ "https://github.com/github/copilot.vim" })

vim.api.nvim_set_keymap("i", "<M-CR>", 'copilot#Accept("<CR>")', { expr = true, noremap = true, silent = true })
vim.g.copilot_no_tab_map = true
vim.g.copilot_workspace_folders = { vim.fn.getcwd() }
