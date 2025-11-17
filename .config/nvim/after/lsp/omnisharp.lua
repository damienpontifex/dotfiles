return {
	cmd = { vim.fn.stdpath("data") .. "/mason/packages/omnisharp/omnisharp" },
	enable_roslyn_analyzers = true,
	organize_imports_on_format = true,
	enable_import_completion = true,
	handlers = {
		-- ['textDocument/definition'] = require('omnisharp_extended').handler,
	},
	settings = {
		RoslynExtensionsOptions = {
			EnableAnalyzersSupport = true,
			EnableImportCompletion = true,
			OrganizeImportsOnFormat = true,
			InlayHintsOptions = {
				EnableForParameters = true,
				ForLiteralParameters = true,
				ForIndexerParameters = true,
				ForObjectCreationParameters = true,
				ForOtherParameters = true,
				SuppressForParametersThatDifferOnlyBySuffix = false,
				SuppressForParametersThatMatchMethodIntent = false,
				SuppressForParametersThatMatchArgumentName = false,
				EnableForTypes = true,
				ForImplicitVariableTypes = true,
				ForLambdaParameterTypes = true,
				ForImplicitObjectCreatio = true,
			},
		},
	},
}
