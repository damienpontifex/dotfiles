-- Load lua files in plugins folder

require("plugins.auto-session")
require("plugins.colorschemes")
require("plugins.dap")
require("plugins.editor")
require("plugins.flash")
require("plugins.formatting")
require("plugins.git")
require("plugins.hardtime")
require("plugins.linting")
require("plugins.lsp")
require("plugins.luasnip")
require("plugins.neo-tree")
require("plugins.tabout")
require("plugins.telescope")
require("plugins.treesitter")
require("plugins.trouble")
require("plugins.ufo")
require("plugins.yazi")

vim.pack.add({
	"https://github.com/numToStr/Comment.nvim",
})
require("Comment").setup()
