vim.pack.add({ "https://github.com/rmagatti/auto-session" })

-- NOTE: 'localoptions' is intentionally omitted. It freezes buffer-local options
-- (incl. indentexpr) into the session file and replays them on restore, which
-- overrides filetype-derived settings (e.g. our treesitter indent autocmd).
vim.o.sessionoptions = "buffers,folds,winsize"

require("auto-session").setup({
	suppressed_dirs = { "~/", "~/Projects", "~/Downloads", "/" },

	-- Saving dap breakpoints
	save_extra_data = function(_)
		local ok, breakpoints = pcall(require, "dap.breakpoints")
		if not ok or not breakpoints then
			return
		end

		local bps = {}
		local breakpoints_by_buf = breakpoints.get()
		for buf, buf_bps in pairs(breakpoints_by_buf) do
			bps[vim.api.nvim_buf_get_name(buf)] = buf_bps
		end
		if vim.tbl_isempty(bps) then
			return
		end
		return vim.fn.json_encode({ breakpoints = bps })
	end,

	-- Restoring dap breakpoints
	restore_extra_data = function(_, extra_data)
		local json = vim.fn.json_decode(extra_data)

		if json.breakpoints then
			local ok, breakpoints = pcall(require, "dap.breakpoints")
			if not ok or not breakpoints then
				return
			end
			vim.notify("restoring breakpoints")
			for buf_name, buf_bps in pairs(json.breakpoints) do
				for _, bp in pairs(buf_bps) do
					local opts = {
						condition = bp.condition,
						log_message = bp.logMessage,
						hit_condition = bp.hitCondition,
					}
					breakpoints.set(opts, vim.fn.bufnr(buf_name), bp.line)
				end
			end
		end
	end,
})
