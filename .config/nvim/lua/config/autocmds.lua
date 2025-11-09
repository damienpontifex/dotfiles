local function augroup(name)
	return vim.api.nvim_create_augroup("pontifex_" .. name, { clear = true })
end

-- resize splits if window got resized
vim.api.nvim_create_autocmd({ "VimResized" }, {
	group = augroup("resize_splits"),
	callback = function()
		local current_tab = vim.fn.tabpagenr()
		vim.cmd("tabdo wincmd =")
		vim.cmd("tabnext " .. current_tab)
	end,
})

-- No auto continue comments on new line
vim.api.nvim_create_autocmd("FileType", {
	group = augroup("no_auto_comment"),
	callback = function()
		vim.opt.formatoptions = vim.opt.formatoptions - { "c", "r", "o" }
	end,
})

-- Only show cursor line in active window
vim.api.nvim_create_autocmd({ "WinEnter", "BufEnter" }, {
	group = augroup("active_cursorline"),
	callback = function()
		vim.opt_local.cursorline = true
	end,
})
vim.api.nvim_create_autocmd({ "WinLeave", "BufLeave" }, {
	group = "pontifex_active_cursorline",
	callback = function()
		vim.opt_local.cursorline = false
	end,
})

-- Highlight references on cursor hold
vim.api.nvim_create_autocmd("CursorMoved", {
	group = vim.api.nvim_create_augroup("LspReferenceHighlight", { clear = true }),
	desc = "Highlight references under cursor",
	callback = function()
		-- Only run if the cursor is not in insert mode
		if vim.fn.mode() == "i" then
			return
		end

		local clients = vim.lsp.get_clients({ bufnr = 0 })
		local supports_highlight = false
		for _, client in pairs(clients) do
			if client.server_capabilities.documentHighlightProvider then
				supports_highlight = true
				break
			end
		end

		if supports_highlight then
			vim.lsp.buf.clear_references()
			vim.lsp.buf.document_highlight()
		end
	end,
})

vim.api.nvim_create_autocmd("CursorMovedI", {
	group = "LspReferenceHighlight",
	desc = "Clear reference highlights on cursor move in insert mode",
	callback = function()
		vim.lsp.buf.clear_references()
	end,
})

-- Auto create dir when saving a file, in case some intermediate directory does not exist
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
	group = augroup("auto_create_dir"),
	callback = function()
		local dir = vim.fn.expand("<afile>:p:h")
		if vim.fn.isdirectory(dir) == 0 then
			vim.fn.mkdir(dir, "p")
		end
	end,
})

-- Open help vertically
vim.api.nvim_create_autocmd("FileType", {
	pattern = "help",
	command = "wincmd L",
})

-- Return to last edit position when opening a file
-- vim.api.nvim_create_autocmd({ "BufReadPost" }, {
--   group = augroup("last_edit_position"),
--   callback = function(event)
--     local mark = vim.api.nvim_buf_get_mark(event.buf, '"')
--     local lcount = vim.api.nvim_buf_line_count(event.buf)
--     if mark[1] > 0 and mark[1] <= lcount then
--       pcall(vim.api.nvim_win_set_cursor, 0, mark)
--     end
--   end,
-- })

-- Check if we need to reload the file when it changed
vim.api.nvim_create_autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
	group = augroup("checktime"),
	callback = function()
		if vim.o.buftype ~= "nofile" then
			vim.cmd("checktime")
		end
	end,
})

-- Highlight on yank
vim.api.nvim_create_autocmd({ "TextYankPost" }, {
	group = augroup("highlight_yamk"),
	pattern = "*",
	desc = "highlight selection on yank",
	callback = function()
		vim.highlight.on_yank({ visual = true, higroup = "Visual", timeout = 200 })
	end,
})

vim.api.nvim_create_autocmd("TermOpen", {
	group = vim.api.nvim_create_augroup("custom-term-open", { clear = true }),
	callback = function()
		-- No line numbers in terminal
		vim.opt.number = false
		vim.opt.relativenumber = false
	end,
})

-- Auto close terminal buffer when process it exits
vim.api.nvim_create_autocmd("TermClose", {
	group = vim.api.nvim_create_augroup("custom-term-close", { clear = true }),
	callback = function()
		if vim.v.event.status == 0 then
			vim.api.nvim_buf_delete(0, {})
		end
	end,
})

-- Save and load session on close and open
-- local session_group = vim.api.nvim_create_augroup("pontifex_session", { clear = true })
-- vim.api.nvim_create_autocmd({ "VimLeave" }, {
--   pattern = "?*",
--   group = session_group,
--   callback = function()
--     vim.cmd([[silent! mksession! .session.vim]])
--   end,
-- })
-- vim.api.nvim_create_autocmd({ "VimEnter" }, {
--   pattern = "?*",
--   group = session_group,
--   callback = function()
--     -- If .session.vim exists in the current directory, load it
--     local session_file = vim.fn.getcwd() .. "/.session.vim"
--     if vim.fn.filereadable(session_file) == 1 then
--       vim.cmd([[silent! source .session.vim]])
--     end
--   end,
-- })
