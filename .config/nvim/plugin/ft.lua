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
	},
	extension = {
		bicep = "bicep",
		bicepparam = "bicep-params",
		gotmpl = "yaml",
		workbook = "json",
		tmpl = "django",
	},
})
