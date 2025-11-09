vim.diagnostic.config({
	virtual_text = false,
	virtual_lines = false,
	severity_sort = true,
	float = {
		border = "rounded",
		source = true,
	},
})

-- Toggle diagnostic text
vim.keymap.set("n", "<leader>td", function()
	local current = vim.diagnostic.config().virtual_text
	vim.diagnostic.config({ virtual_text = not current })
	if not current then
		vim.notify("Diagnostics enabled", vim.log.levels.INFO, { title = "LSP" })
	else
		vim.notify("Diagnostics disabled", vim.log.levels.INFO, { title = "LSP" })
	end
end, { desc = "Toggle diagnostics" })

vim.api.nvim_create_autocmd({ "LspAttach" }, {
	group = vim.api.nvim_create_augroup("my.lsp", {}),
	callback = function(args)
		local client = assert(vim.lsp.get_client_by_id(args.data.client_id), "must have valid client")
		local bufnr = args.buf

		-- If filetype is 'codecompanion', or any of the Avante panels then return early and don't setup any of the lsp keymaps or autocommands
		if vim.bo[bufnr].filetype == "codecompanion" or vim.bo[bufnr].filetype:match("^Avante") then
			return
		end
		if client.name == "GitHub Copilot" then
			return
		end

		if client.name == "bicep" then
			vim.lsp.set_log_level("TRACE")
		end

		-- TODO: refine
		if client.name == "rust_analyzer" then
			vim.lsp.commands["rust-analyzer.debugSingle"] = function(params)
				local has_dap, dap = pcall(require, "dap")
				if not has_dap then
					vim.notify("nvim-dap not found.", vim.log.levels.ERROR, { title = "LSP" })
					return
				end

				local runnable = params.arguments[1]
				-- print("Debug args: %s", vim.inspect(args))
				--   Debug args: %s {
				--   args = {
				--     cargoArgs = { "run", "--package", "<package-name>", "--bin", "<package-name>" },
				--     cwd = "<my-cwd>",
				--     environment = {
				--       RUSTC_TOOLCHAIN = "<toolchain-path>"
				--     },
				--     executableArgs = {},
				--     workspaceRoot = "<workspace-root-dir>"
				--   },
				--   kind = "cargo",
				--   label = "run <package-name>",
				--   location = {
				--     targetRange = {
				--       ["end"] = {
				--         character = 1,
				--         line = 53
				--       },
				--       start = {
				--         character = 0,
				--         line = 38
				--       }
				--     },
				--     targetSelectionRange = {
				--       ["end"] = {
				--         character = 13,
				--         line = 39
				--       },
				--       start = {
				--         character = 9,
				--         line = 39
				--       }
				--     },
				--     targetUri = "file:///<path-to-file>/src/main.rs"
				--   }
				-- }
				local cargo_args = vim.iter({ runnable.args.cargoArgs, "--message-format=json" }):flatten():totable()
				if cargo_args[1] == "run" then
					cargo_args[1] = "build"
				elseif cargo_args[1] == "test" then
					if not vim.list_contains(cargo_args, "--no-run") then
						table.insert(cargo_args, "--no-run")
					end
				end

				vim.system(
					vim.iter({ "cargo", cargo_args }):flatten():totable(),
					{ cwd = runnable.args.workspaceRoot },
					---@param result vim.SystemCompleted
					vim.schedule_wrap(function(result)
						if result.code > 0 then
							vim.notify(
								"Cargo build failed:\n" .. result.stderr,
								vim.log.levels.ERROR,
								{ title = "LSP" }
							)
							return
						end
						vim.notify("Cargo build succeeded.", vim.log.levels.INFO, { title = "LSP" })

						local executables = {}
						for _, value in ipairs(vim.split(result.stdout or "", "\n", { trimempty = true })) do
							local artifact = vim.json.decode(value, { luanil = { object = true } })
							if artifact.reason == "compiler-artifact" and artifact.executable then
								local is_binary = vim.list_contains(artifact.target.crate_types, "bin")
								local is_build_script = vim.list_contains(artifact.target.crate_types, "custom-build")
								if
									(cargo_args[1] == "build" and is_binary and not is_build_script)
									or (cargo_args[1] == "test" and artifact.profile.test)
								then
									table.insert(executables, artifact.executable)
								end
							end
						end

						if #executables == 0 then
							vim.notify("No compilation artifacts found", vim.log.levels.WARN)
							return
						elseif #executables > 1 then
							vim.notify(
								"Multiple compilation artifacts found, using the first one: "
									.. table.concat(executables, ", "),
								vim.log.levels.WARN
							)
							-- TODO: could use a picker here to select which one to debug
							return
						end

						local dap_config = {
							name = "Debug " .. runnable.label,
							type = "codelldb",
							request = "launch",
							program = executables[1],
							args = runnable.args.executableArgs,
							cwd = vim.fs.root(0, "Cargo.toml") or runnable.args.workspaceRoot,
							console = "internalConsole",
							stopOnEntry = false,
						}
						vim.lsp.log.debug("Launching DAP with config: %s", dap_config)
						dap.run(dap_config)
					end)
				)
			end
		end

		-- if client.server_capabilities.executeCommandProvider then
		--   for _, command in pairs(client.server_capabilities.executeCommandProvider.commands) do
		--     -- Strip everything up to the last dot from command
		--     local command_name = command:match('%.([^%.]+)$') or command
		--     print('Adding command: ', command_name, ' for client: ', client.name)
		--     client.commands[command_name] = function()
		--       client.exec_cmd(command, { bufnr = vim.api.nvim_buf_get_name(bufnr) })
		--     end
		--     print('LSP command: ', command)
		--   end
		-- end

		-- print(vim.inspect(client.server_capabilities))
		local lsp_group = vim.api.nvim_create_augroup("my.lsp", { clear = false })

		-- vim.api.nvim_create_autocmd('CursorHold', {
		--   group = lsp_group,
		--   buffer = bufnr,
		--   callback = function()
		--     vim.diagnostic.open_float(nil, { scope = 'cursor', border = 'rounded', focusable = false, })
		--   end
		-- })

		-- Auto format on save
		-- if client:supports_method('textDocument/formatting') then
		--   --if client.server_capabilities.documentFormattingProvider or client.name == 'bicep' then
		--   vim.api.nvim_create_autocmd('BufWritePre', {
		--     group = lsp_group,
		--     buffer = bufnr,
		--     callback = function()
		--       vim.lsp.buf.format({ bufnr = bufnr, async = false, id = client.id, timeout_ms = 1000 })
		--     end
		--   })
		-- else
		--   print('LSP client ' .. client.name .. ' does not support document formatting')
		-- end

		if client.server_capabilities.colorProvider and vim.lsp.document_color then
			vim.lsp.document_color.enable(true, bufnr)
		end

		if client.server_capabilities.foldingRangeProvider then
			-- Use LSP for folding of the current buffer
			local winid = vim.api.nvim_get_current_win()
			vim.wo[winid][0].foldmethod = "expr"
			vim.wo[winid][0].foldexpr = "v:lua.vim.lsp.foldexpr()"
		end

		-- if client.server_capabilities.inlayHintProvider then
		vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
		-- end

		-- if client.server_capabilities.codeLensProvider then
		vim.lsp.codelens.refresh()
		vim.api.nvim_create_autocmd(
			{ "BufEnter", "InsertLeave" }, -- 'CursorHold',  },
			{
				group = lsp_group,
				buffer = bufnr,
				callback = function()
					vim.lsp.codelens.refresh({ bufnr = bufnr })
				end,
			}
		)
		-- end

		-- Not using in favour of blink.cmp
		-- if client.server_capabilities.completionProvider then
		--   vim.bo[bufnr].omnifunc = 'v:lua.vim.lsp.omnifunc'
		--   vim.lsp.completion.enable(true, client.id, bufnr, { autotrigger = true })
		--   vim.keymap.set('i', '<C-Space>', vim.lsp.completion.get, { desc = 'LSP: Trigger completion', buffer = bufnr })
		-- end

		if client:supports_method(vim.lsp.protocol.Methods.textDocument_inlineCompletion) then
			if vim.fn.has("nvim-0.12") == 1 then
				vim.lsp.inline_completion.enable(true)
				vim.keymap.set("n", "<M-CR>", function()
					if not vim.lsp.inline_completion.get() then
						return "<M-CR>"
					end
				end, {
					expr = true,
					replace_keycodes = true,
					desc = "LSP: Accept inline completion",
					buffer = bufnr,
				})
			end
		end

		local opts = { buffer = bufnr }

		local builtin = require("telescope.builtin")
		vim.keymap.set("n", "gd", builtin.lsp_definitions, opts)
		vim.keymap.set("n", "gD", function()
			builtin.lsp_definitions({ jump_type = "vsplit" })
		end, opts)
		vim.keymap.set("n", "<leader>sd", builtin.diagnostics, { desc = "[S]earch [D]iagnostics", buffer = bufnr })
		vim.keymap.set("n", "gi", vim.lsp.buf.implementation, { desc = "LSP: Go to Implementation", buffer = bufnr })
		-- vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
		vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "LSP: Hover", buffer = bufnr })
		vim.keymap.set("n", "<C-]>", vim.lsp.buf.definition, { desc = "LSP: Go to Definition", buffer = bufnr })
		vim.keymap.set("n", "gr", vim.lsp.buf.references, { desc = "LSP: References", buffer = bufnr })
		vim.keymap.set("n", "<F12>", vim.lsp.buf.references, { desc = "LSP: References", buffer = bufnr })
		vim.keymap.set("n", "<leader>cr", vim.lsp.buf.rename, { desc = "LSP: Rename", buffer = bufnr })
		vim.keymap.set("n", "<F2>", vim.lsp.buf.rename, { desc = "LSP: Rename", buffer = bufnr })
		vim.keymap.set("n", "ca", vim.lsp.buf.code_action, { desc = "LSP: Code Action", buffer = bufnr })
		vim.keymap.set("n", "gr", builtin.lsp_references, { desc = "LSP: References", buffer = bufnr })
		vim.keymap.set("n", "g0", vim.lsp.buf.document_symbol, { desc = "LSP: Document Symbols", buffer = bufnr })
		vim.keymap.set("n", "gW", vim.lsp.buf.workspace_symbol, { desc = "LSP: Workspace Symbols", buffer = bufnr })
		vim.keymap.set("n", "<C-t>", builtin.lsp_document_symbols, { desc = "LSP: workspace symbols", buffer = bufnr })
		vim.keymap.set("n", "<leader>cr", vim.lsp.codelens.run, { desc = "LSP: Run CodeLens", buffer = bufnr })

		vim.keymap.set("n", "<leader>dn", function()
			vim.diagnostic.jump({ count = 1, float = true })
		end, { desc = "LSP: Next Diagnostic", buffer = bufnr })
		vim.keymap.set("n", "<leader>dp", function()
			vim.diagnostic.jump({ count = -1, float = true })
		end, { desc = "LSP: Previous Diagnostic", buffer = bufnr })
		vim.keymap.set(
			"n",
			"<leader>ds",
			vim.diagnostic.open_float,
			{ desc = "LSP: Show Diagnostic in float", buffer = bufnr }
		)
		vim.keymap.set("n", "<leader>af", vim.lsp.buf.code_action, { desc = "LSP: Code Action", buffer = bufnr })
		vim.keymap.set("n", "<leader>kf", vim.lsp.buf.format, { desc = "LSP: Format file", buffer = bufnr })

		vim.keymap.set("n", "<leader>f", vim.lsp.buf.format, { desc = "LSP: Format file", buffer = bufnr })

		-- https://github.com/OmniSharp/omnisharp-roslyn/issues/2483
		local function toSnakeCase(str)
			return string.gsub(str, "%s*[- ]%s*", "_")
		end

		if client.name == "omnisharp" then
			local tokenModifiers = client.server_capabilities.semanticTokensProvider.legend.tokenModifiers
			for i, v in ipairs(tokenModifiers) do
				tokenModifiers[i] = toSnakeCase(v)
			end
			local tokenTypes = client.server_capabilities.semanticTokensProvider.legend.tokenTypes
			for i, v in ipairs(tokenTypes) do
				tokenTypes[i] = toSnakeCase(v)
			end
		end
	end,
})

-- vim.lsp.enable('bicep')
