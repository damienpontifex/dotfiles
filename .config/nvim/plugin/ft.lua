vim.filetype.add({
	filename = {
		[".env"] = "sh",
		[".envrc"] = "sh",
		["*.env"] = "sh",
		["*.envrc"] = "sh",
		["*.env.*"] = "sh",
	},
	pattern = {
		["Brewfile.*"] = "ruby",
	},
	extension = {
		bicep = "bicep",
		bicepparam = "bicep-params",
		gotmpl = "yaml",
		workbook = "json",
	},
})
