return {
	settings = {
		-- https://github.com/redhat-developer/yaml-language-server#language-server-settings
		yaml = {
			hierarchicalDocumentSymbolSupport = true,
			schemaStore = { enable = false, url = "" },
			schemas = vim.tbl_deep_extend("force", require("schemastore").yaml.schemas(), {
				["kubernetes"] = {
					"*.k8s.yaml",
					"k8s/**/*.yaml",
					"kube/**/*.yaml",
					"kubernetes/**/*.yaml",
					"manifests/**/*.yaml",
				},
			}),
			kubernetesCRDStore = { enable = true },
			format = {
				enable = false,
				singleQuote = false,
			},
			validate = true,
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
