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
require(folderOfThisFile .. "ai")
require(folderOfThisFile .. "snacks")
require(folderOfThisFile .. "dap")

vim.pack.add({
	"https://github.com/numToStr/Comment.nvim",
})

require("Comment").setup()
