return {
	{ -- Formatting
		"stevearc/conform.nvim",
		opts = {
			log_level = vim.log.levels.INFO,
			format_on_save = {
				timeout_ms = 1000,
				lsp_format = "fallback",
			},
			formatters = {
				detekt = {
					command = "detekt",
					cwd = function(_, ctx)
						return vim.fs.root(ctx.dirname, { "detekt.yaml", "detekt.yml" })
					end,
					require_cwd = true,
					exit_codes = { 0, 2, 3 },
					stdin = false,
					-- "--parallel", Could use this, but passing --input so only single file. Maybe use this if doing project wide
					args = {
						"--auto-correct",
						"--build-upon-default-config",
						"--config",
						vim.fn.expand("detekt.y*ml"),
						"--plugins",
						-- Find the first file matching detekt-formatting-*.jar under the ~/.gradle/caches/modules-2/files-2.1 directory
						-- to use for formatting plugin
						vim.fn.expand(
							"~/.gradle/caches/modules-2/files-2.1/io.gitlab.arturbosch.detekt/detekt-formatting/**/detekt-formatting-*.jar"
						),
						"--input",
						"$FILENAME",
					},
				},
			},
			formatters_by_ft = {
				-- bicep = { "bicep" },
				cs = { "csharpier" },
				go = { "goimports", "gofmt" },
				html = { "djlint" },
				json = { "jq" },
				kotlin = { "detekt" },
				lua = { "stylua" },
				rust = { "rustfmt" },
				typescript = { "prettierd", "prettier", "eslint", stop_after_first = true },
				xml = { "xmlformatter" },
				-- yaml = { "yamlfmt" },
				-- ["*"] = { "codespell", "trim_whitespace" },
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
		event = { "BufReadPost", "BufNewFile" },
		config = function()
			local lint = require("lint")

			-- Custom detekt linter configuration
			lint.linters.detekt = {
				cmd = "detekt",
				stdin = false,
				append_fname = true,
				args = {
					"--build-upon-default-config",
					"--config",
					vim.fn.expand("detekt.y*ml"),
					"--plugins",
					-- Find the first file matching detekt-formatting-*.jar under the ~/.gradle/caches/modules-2/files-2.1 directory
					-- to use for formatting plugin
					vim.fn.expand(
						"~/.gradle/caches/modules-2/files-2.1/io.gitlab.arturbosch.detekt/detekt-formatting/**/detekt-formatting-*.jar"
					),
					"--input",
				},
				stream = nil,
				ignore_exitcode = true,
				parser = require("lint.parser").from_errorformat("%f:%l:%c: %m"),
			}

			lint.linters_by_ft = {
				-- markdown = { 'markdownlint' },
				kotlin = { "detekt" },
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
		event = "BufReadPre",
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
				"kotlin_lsp",
				"gradle_ls",
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
				-- opts = {
				-- 	registries = {
				-- 		"github:mason-org/mason-registry",
				-- 		"github:Crashdummyy/mason-registry",
				-- 	},
				-- },
			},
			{ "Joakker/lua-json5", build = "./install.sh" }, -- Allows trailing comman in .vscode/mcp.json
		},
		config = function(_, opts)
			require("mason").setup()
			require("mason-lspconfig").setup(opts)

			-- Ensure that other tools, apart from LSP servers, are installed.
			local registry = require("mason-registry")

			local dap_servers = { "js-debug-adapter", "bash-debug-adapter", "netcoredbg", "codelldb", "debugpy" }
			local linters_and_formatters = {
				"biome",
				"detekt",
				"djlint",
				"eslint_d",
				"prettierd",
				"prettier",
				"shellcheck",
				"csharpier",
				"xmlformatter",
				"stylua",
				"yamlfmt",
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
