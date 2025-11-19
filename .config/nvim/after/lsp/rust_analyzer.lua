-- Because this file is run before lazy.nvim is loaded, we need to ensure that the
-- json5 module is available in the package path.
local mod_dir = vim.fn.stdpath("data") .. "/lazy/lua-json5/lua"
package.cpath = mod_dir .. "/?.so;" .. mod_dir .. "/?.dylib;" .. package.cpath

local function get_project_rustanalyzer_settings()
	local handle = io.open(vim.fn.resolve(vim.fn.getcwd() .. "/rust-analyzer.json"), "r")
	if not handle then
		return {}
	end
	local out = handle:read("*a")
	handle:close()
	-- local config = vim.json.decode(out)
	local config = require("json5").parse(out)
	if type(config) == "table" then
		return config
	end
	return {}
end

-- e.g. .vscode/settings.json for embedded development
-- {
--   "rust-analyzer.cargo.allTargets": false,
--   "rust-analyzer.cargo.target": "riscv32imac-unknown-none-elf"
-- }

local function get_vscode_rustanalyzer_settings()
	local handle = io.open(vim.fn.resolve(vim.fn.getcwd() .. "/.vscode/settings.json"), "r")
	if not handle then
		return {}
	end
	local out = handle:read("*a")
	handle:close()
	--local config = vim.json.decode(out)
	local config = require("json5").parse(out)
	if type(config) ~= "table" then
		return config
	end
	-- Filter to only keys in the table that start with 'rust-analyzer.'
	local rust_analyzer_settings = {}
	for key, value in pairs(config) do
		if key:match("^rust%-analyzer%.") then
			-- Stip the prefix of 'rust-analyzer.' from the key
			local new_key = key:gsub("^rust%-analyzer%.", "")
			-- Then for each '.' within the key, map it into a nested table unless it's the last part, then it should be set as the value
			local parts = vim.split(new_key, "%.")
			local current = rust_analyzer_settings
			for i, part in ipairs(parts) do
				if i == #parts then
					current[part] = value -- Set the value for the last part
				else
					current[part] = current[part] or {} -- Create a nested table if it doesn't exist
					current = current[part] -- Move deeper into the nested table
				end
			end
		end
	end
	return rust_analyzer_settings
end

-- Configuration settings https://rust-analyzer.github.io/book/configuration.html
local rust_default_settings = {
	check = {
		-- Use clippy for `cargo check`
		command = "clippy",
	},
	diagnostics = { styleLints = { enable = true } },
	assist = {
		importGranularity = "module",
		importPrefix = "by_self",
	},
	-- imports = {
	--   preferNoStd = true,
	-- },
	cargo = {
		loadOutDirsFromCheck = true,
	},
	procMacro = { enable = true },
	inlayHints = {
		parameterHints = { type = { enable = true } },
		typeHints = { enable = true, hideNamedConstructor = false, hideClosureInitialization = false },
		bindingModeHints = { enable = false },
		chainingHints = { enable = true },
		closingBraceHints = { enable = true, minLines = 25 },
		closureReturnTypeHints = { enable = "never" },
		lifetimeElisionHints = { enable = "never", useParameterNames = false },
	},
	lens = {
		enable = true,
		references = { method = { enable = true } },
		parameters = { enable = true },
	},
}

return {
	settings = {
		["rust-analyzer"] = vim.tbl_deep_extend(
			"force",
			rust_default_settings,
			get_vscode_rustanalyzer_settings(),
			get_project_rustanalyzer_settings()
		),
	},
}
