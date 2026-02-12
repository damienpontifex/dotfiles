return {
	settings = {
		-- https://github.com/redhat-developer/yaml-language-server#language-server-settings
		yaml = {
			hierarchicalDocumentSymbolSupport = true,
			schemaStore = { enable = false, url = "" },
			schemas = vim.tbl_deep_extend("force", require("schemastore").yaml.schemas(), {
				["kubernetes"] = "*.yaml",
			}),
			kubernetesCRDStore = { enable = true },
		},
	},
	capabilities = {
		textDocument = {
			documentSymbol = {
				hierarchicalDocumentSymbolSupport = true,
			},
		},
	},
}
