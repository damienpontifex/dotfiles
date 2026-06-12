-- Load lua files in plugins folder

require("plugins.lsp")
require("plugins.auto-session")
require("plugins.editor")
require("plugins.git")
require("plugins.linting")
require("plugins.tabout")
require("plugins.trouble")
require("plugins.colorschemes")
require("plugins.flash")
require("plugins.hardtime")
require("plugins.telescope")
require("plugins.ufo")
require("plugins.dap")
require("plugins.formatting")
require("plugins.luasnip")
require("plugins.treesitter")
require("plugins.yazi")

vim.pack.add({
	"https://github.com/numToStr/Comment.nvim",
})
require("Comment").setup()
