local folderOfThisFile = (...) .. "."

require(folderOfThisFile .. "colorschemes")
require(folderOfThisFile .. "lsp")
require(folderOfThisFile .. "treesitter")
require(folderOfThisFile .. "telescope")
require(folderOfThisFile .. "git")
require(folderOfThisFile .. "editor")
require(folderOfThisFile .. "flash")
require(folderOfThisFile .. "yazi")
require(folderOfThisFile .. "tabout")
require(folderOfThisFile .. "ufo")
require(folderOfThisFile .. "trouble")
require(folderOfThisFile .. "auto-session")
require(folderOfThisFile .. "hardtime")
require(folderOfThisFile .. "dap")

vim.pack.add({
	"https://github.com/numToStr/Comment.nvim",
})

require("Comment").setup()

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
