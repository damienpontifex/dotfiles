vim.filetype.add({
	filename = {
		[".env"] = "sh",
		[".envrc"] = "sh",
		["*.env"] = "sh",
		["*.envrc"] = "sh",
		["*.env.*"] = "sh",
		["kuberc"] = "yaml",
		["justfile"] = "make",
	},
	pattern = {
		[".*%.env%..*"] = "sh",
		["Brewfile.*"] = "ruby",
		[".*/templates/.*%.tpl"] = "helm",
		[".*/templates/.*%.yaml"] = "helm",
		[".*/templates/.*%.yml"] = "helm",
		["helmfile.*%.yaml"] = "helm",
		["helmfile.*%.yml"] = "helm",
	},
	extension = {
		bicep = "bicep",
		bicepparam = "bicep-params",
		gotmpl = "yaml",
		workbook = "json",
		tmpl = "django",
	},
})
