return {
	settings = {
		yaml = {
			schemaStore = { enable = false, url = "" },
			schemas = vim.tbl_deep_extend("force", require("schemastore").yaml.schemas(), {
				["kubernetes"] = "*.yaml",
			}),
		},
	},
}
