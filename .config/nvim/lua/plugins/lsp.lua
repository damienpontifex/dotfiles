return {
	{ -- Formatting
		"stevearc/conform.nvim",
		opts = {
			log_level = vim.log.levels.INFO,
			format_on_save = {
				timeout_ms = 500,
				lsp_format = "fallback",
			},
			formatters_by_ft = {
				-- bicep = { "bicep" },
				cs = { "csharpier" },
				go = { "goimports", "gofmt" },
				json = { "jq" },
				lua = { "stylua" },
				rust = { "rustfmt" },
				typescript = { "prettierd", "prettier", "eslint", stop_after_first = true },
				xml = { "xmlformatter" },
				yaml = { "yq" },
			},
		},
		config = function(_, opts)
			require("conform").setup(opts)

			vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"

			-- Override '=' that would normally run 'equalprg'
			vim.keymap.set({ "n", "v" }, "=", function()
				require("conform").format({ async = true, lsp_fallback = true }, function(err)
					if not err then
						-- If we formatted in visual mode, escape to normal mode after formatting
						if vim.startswith(vim.api.nvim_get_mode().mode:lower(), "v") then
							vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", true)
						end
					end
				end)
			end, { desc = "Format buffer" })
		end,
	},
	{ -- Linting
		"mfussenegger/nvim-lint",
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			local lint = require("lint")
			lint.linters_by_ft = {
				-- markdown = { 'markdownlint' },
				typescript = { "biomejs" },
				sh = { "shellcheck" },
			}

			local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })
			vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
				group = lint_augroup,
				callback = function()
					if vim.bo.modifiable then
						lint.try_lint()
					end
				end,
			})
		end,
	},
	{ -- Useful status updates for LSP.
		"j-hui/fidget.nvim",
		opts = {},
	},
	{
		"rachartier/tiny-inline-diagnostic.nvim",
		event = "VeryLazy",
		priority = 1000,
		opts = {},
	},
	{ -- Autocompletion
		"saghen/blink.cmp",
		event = "VimEnter",
		dependencies = {
			"rafamadriz/friendly-snippets",
			"Kaiser-Yang/blink-cmp-avante",
		},
		version = "1.*",
		opts = {
			keymap = { preset = "default" },
			-- Add 'avante' to the list
			-- default = { 'avante', 'lsp', 'path', 'luasnip', 'buffer' },
			appearance = {
				nerd_font_variant = "mono",
			},
			signature = { enabled = true },
			cmdline = {
				completion = {
					menu = { auto_show = true },
				},
			},
			-- providers = {
			--   avante = {
			--     module = 'blink-cmp-avante',
			--     name = 'Avante',
			--     opts = {
			--       -- options for blink-cmp-avante
			--     }
			--   }
			-- },
		},
	},
	{ -- LSP Configuration
		"mason-org/mason-lspconfig.nvim",
		event = "VimEnter",
		opts = {
			automatic_enable = true,
			ensure_installed = {
				"bashls",
				"bicep",
				"copilot", -- After nvim-0.12 Can sign in/out with commands LspCopilotSignIn and LspCopilotSignOut
				"docker_compose_language_service",
				"dockerls",
				"gopls",
				"helm_ls",
				"lua_ls",
				-- 'omnisharp',
				"rust_analyzer",
				"terraformls",
				"ts_ls",
				"yamlls",
				"jsonls",
				"pyright",
			},
		},
		dependencies = {
			-- see `set runtimepath?` and nvim-lspconfig is on runtimepath, so lsp folder within that is automatically included in config setup
			"neovim/nvim-lspconfig",
			{
				"mason-org/mason.nvim",
				opts = {
					registries = {
						"github:mason-org/mason-registry",
						"github:Crashdummyy/mason-registry",
					},
				},
			},
			{ "Joakker/lua-json5", build = "./install.sh" }, -- Allows trailing comman in .vscode/mcp.json
		},
		config = function(_, opts)
			require("mason-lspconfig").setup(opts)

			-- Ensure that other tools, apart from LSP servers, are installed.
			local registry = require("mason-registry")

			local dap_servers = { "js-debug-adapter", "bash-debug-adapter", "netcoredbg", "codelldb", "debugpy" }
			local linters_and_formatters = {
				"biome",
				"eslint_d",
				"prettierd",
				"prettier",
				"shellcheck",
				"csharpier",
				"xmlformatter",
				"stylua",
			}
			local other_lsp_servers = { "rolsyn" }

			for _, pkg_name in
				ipairs(vim.tbl_deep_extend("force", dap_servers, linters_and_formatters, other_lsp_servers))
			do
				local ok, pkg = pcall(registry.get_package, pkg_name)
				if ok then
					if not pkg:is_installed() then
						pkg:install()
					end
				end
			end
		end,
	},
	-- {
	--   "seblyng/roslyn.nvim",
	--   opts = {
	--   },
	-- },
	-- 'Hoffs/omnisharp-extended-lsp.nvim',
	"b0o/schemastore.nvim",
}
