vim.diagnostic.config({
	virtual_text = false,
	virtual_lines = false,
	severity_sort = true,
	float = {
		border = "rounded",
		source = true,
	},
})

vim.keymap.set("n", "<leader>dq", function()
	vim.diagnostic.setqflist()
	vim.cmd("copen")
end, { silent = true })

-- Toggle diagnostic text
vim.keymap.set("n", "<leader>td", function()
	local current = vim.diagnostic.config().virtual_text
	vim.diagnostic.config({ virtual_text = not current })
	if not current then
		vim.notify("Diagnostics enabled", vim.log.levels.INFO, { title = "LSP" })
	else
		vim.notify("Diagnostics disabled", vim.log.levels.INFO, { title = "LSP" })
	end
end, { desc = "Toggle diagnostics" })
