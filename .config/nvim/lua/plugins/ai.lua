return {
  {
    'github/copilot.vim',
    event = 'InsertEnter',
    init = function()
      vim.g.copilot_no_tab_map = true
      vim.g.copilot_workspace_folders = { vim.fn.getcwd() }
      -- Only accept one line at a time
      vim.keymap.set('i', '<Tab>', 'copilot#AcceptLine()', { expr = true, replace_keycodes = false, })
    end,
  },
  {
    'ravitemer/mcphub.nvim',
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    build = "npm install -g mcp-hub@latest", -- Installs `mcp-hub` node binary globally
    opts = {
      log = {
        level = vim.log.levels.INFO,
      },
    },
    -- config = function(_, opts)
    --   require("mcphub").setup(opts)
    -- end
  },
  {
    "olimorris/codecompanion.nvim",
    event = "VimEnter",
    -- Defaults https://github.com/olimorris/codecompanion.nvim/blob/main/lua/codecompanion/config.lua
    opts = {
      -- TODO: Figure out how to conditionally override the system prompt
      -- system_prompt = function(opts)
      --   print(vim.inspect(opts))
      --   -- Provide VSCode github copilot instructions as system prompt if they exist
      --   local handle = io.open(vim.fn.resolve(vim.fn.getcwd() .. '/.github/copilot-instructions.md'), 'r')
      --   if not handle then
      --     return nil
      --   end
      --   local out = handle:read('*a')
      --   handle:close()
      --   return out
      -- end,
      strategies = {
        chat = {
          adapter = {
            name = 'copilot',
            model = 'claude-sonnet-4',
          },
          tools = {
            opts = {
              default_tools = {
                'full_stack_dev',
              },
            },
          },
        },
      },
      display = {
        chat = {
          start_in_insert_mode = true,
          show_settings = true,
        },
      },
      extensions = {
        mcphub = {
          callback = 'mcphub.extensions.codecompanion',
          opts = {
            show_results_in_chat = true,
            make_vars = true,
            make_slash_commands = true,
          },
        },
      },
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "j-hui/fidget.nvim",
    },
    keys = {
      { '<Leader>a', '<cmd>CodeCompanionChat Toggle<CR>', desc = 'Toggle chat buffer' },
      {
        '<Leader>i',
        '<cmd>CodeCompanion<CR>',
        desc = 'Code companion inline chat',
        mode = { 'n', 'v' }
      },
    },
    config = function(_, opts)
      require('codecompanion').setup(opts)

      local progress = require('fidget.progress')
      local handles = {}
      local group = vim.api.nvim_create_augroup('CodeCompanionFidgetHooks', { clear = true })

      vim.api.nvim_create_autocmd('User', {
        pattern = 'CodeCompanionRequestStarted',
        group = group,
        callback = function(e)
          handles[e.data.id] = progress.handle.create({
            title = " Requesting assistance (" .. e.data.strategy .. ")",
            message = 'In progress...',
            lsp_client = { name = e.data.adapter.formatted_name },
          })
        end
      })

      vim.api.nvim_create_autocmd('User', {
        pattern = "CodeCompanionRequestFinished",
        group = group,
        callback = function(e)
          local handle = handles[e.data.id]
          if handle then
            handle.message = e.data.status == "success" and 'Done!' or 'Error!'
            handle:finish()
            handles[e.data.id] = nil
          end
        end
      })
    end
  },
}
