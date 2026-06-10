-- Package manager
vim.api.nvim_create_user_command("PackClean", function()
	local non_active = vim.iter(vim.pack.get())
		:filter(function(x)
			return not x.active
		end)
		:map(function(x)
			return x.spec.name
		end)
		:totable()

	if #non_active == 0 then
		vim.notify("No plugins to clean", vim.log.levels.INFO)
		return
	end

	vim.pack.del(non_active)
	vim.notify("Deleted " .. #non_active .. " non-active plugins", vim.log.levels.INFO)
end, { desc = "Clean inactive plugsin" })

vim.api.nvim_create_user_command("PackUpdate", function()
	vim.pack.update()
end, { desc = "Update all plugsin" })

-- Copying paths
local function copy_to_clipboard(expression)
	local path = vim.fn.expand(expression)
	vim.fn.setreg("+", path)
end

vim.api.nvim_create_user_command("CopyRelativePath", function()
	copy_to_clipboard("%:.")
end, { desc = "Copy relative path to the clipboard" })

vim.api.nvim_create_user_command("CopyAbsolutePath", function()
	copy_to_clipboard("%:p")
end, { desc = "Copy absolute path to the clipboard" })

vim.api.nvim_create_user_command("CopyPathWithLineNumber", function(opts)
	local path = vim.fn.expand("%:.")

	-- Check if command was called with a range (visual mode or :line1,line2 syntax)
	if opts.range > 0 then
		local line_start = opts.line1
		local line_end = opts.line2

		if line_start == line_end then
			-- Single line: path:n
			copy_to_clipboard(path .. ":" .. line_start)
		else
			-- Range: path:n-m
			copy_to_clipboard(path .. ":" .. line_start .. "-" .. line_end)
		end
	else
		-- Normal mode: just the path
		copy_to_clipboard(path)
	end
end, { range = true, desc = "Copy relative path with optional line number(s)" })

vim.keymap.set({ "n", "v" }, "<leader>cp", ":CopyPathWithLineNumber<CR>", { desc = "Copy relative path to clipboard" })
