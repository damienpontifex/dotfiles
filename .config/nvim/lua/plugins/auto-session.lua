return {
	"rmagatti/auto-session",
	lazy = false,

	---enables autocomplete for opts
	---@module "auto-session"
	---@type AutoSession.Config
	opts = {
		suppressed_dirs = { "~/", "~/Projects", "~/Downloads", "/" },
		-- log_level = 'debug',
		-- Saving dap breakpoints https://github.com/rmagatti/auto-session?tab=readme-ov-file#%EF%B8%8F-saving-custom-data
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
			local extra_data = {
				breakpoints = bps,
			}
			return vim.fn.json_encode(extra_data)
		end,

		-- Restoring dap breakpoints https://github.com/rmagatti/auto-session?tab=readme-ov-file#%EF%B8%8F-saving-custom-data
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
						local line = bp.line
						local opts = {
							condition = bp.condition,
							log_message = bp.logMessage,
							hit_condition = bp.hitCondition,
						}
						breakpoints.set(opts, vim.fn.bufnr(buf_name), line)
					end
				end
			end
		end,
	},
	config = function(_, opts)
		vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"

		require("auto-session").setup(opts)
	end,
}
