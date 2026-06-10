-- Load lua files in plugins folder
local config_dir = vim.fn.stdpath("config") .. "/lua/plugins"
local files = vim.fn.split(vim.fn.glob(config_dir .. "/*.lua"), "\n")
for _, file in ipairs(files) do
	-- Extract the module name out of the absolute path
	local module_name = file:match("([^/]+)%.lua$")
	if module_name ~= "init" then
		require("plugins." .. module_name)
	end
end

vim.pack.add({
	"https://github.com/numToStr/Comment.nvim",
})
require("Comment").setup()
