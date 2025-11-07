if vim.fn.has("nvim-0.12") == 1 then
	-- Built in to 0.12 https://github.com/neovim/neovim/pull/28176
	return {}
else
	return {
		"numToStr/Comment.nvim",
	}
end
