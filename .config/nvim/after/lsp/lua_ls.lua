return {
	settings = {
		Lua = {
			workspace = {
				-- Dynamically source VIMRUNTIME and all active plugin directories
				library = vim.api.nvim_get_runtime_file("lua", true),
				-- Prevents lua_ls from scanning huge, irrelevant directories
				checkThirdParty = false,
			},
			hint = { enable = true },
		},
	},
}
