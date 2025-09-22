vim.filetype.add({
	filename = {
		[".Brewfile"] = "ruby",
		[".env"] = "sh",
		[".envrc"] = "sh",
		["*.env"] = "sh",
		["*.envrc"] = "sh",
		["*.env.*"] = "sh",
	},
	extension = {
		bicep = "bicep",
		bicepparam = "bicep-params",
		gotmpl = "yaml",
		workbook = "json",
	},
})
