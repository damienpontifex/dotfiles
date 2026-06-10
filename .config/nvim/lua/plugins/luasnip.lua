vim.pack.add({
	"https://github.com/L3MON4D3/LuaSnip",
})

require("luasnip.loaders.from_vscode").lazy_load({
	paths = { vim.fn.stdpath("config") .. "/snippets" },
})
