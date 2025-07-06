return {
  {
    'github/copilot.vim'
  },
  {
    "olimorris/codecompanion.nvim",
    opts = {
      system_prompt = function()
        -- Provide VSCode github copilot instructions as system prompt if they exist
        local handle = io.open(vim.fn.resolve(vim.fn.getcwd() .. '/.github/copilot-instructions.md'), 'r')
        if not handle then
          return nil
        end
        local out = handle:read('*a')
        handle:close()
        return out
      end,
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "j-hui/fidget.nvim",
    },
    keys = {
      { '<Leader>a', '<cmd>CodeCompanionChat Toggle<CR>', desc = 'Toggle chat buffer' },
    },
    config = function(_, opts)
      require('codecompanion').setup(opts)

      -- local progress = require('fidget.progress')
      -- local handles = {}
      -- local group = vim.api.nvim_create_augroup('CodeCompanionHooks', { clear = true })
      --
      -- vim.api.nvim_create_autocmd('User', {
      --   pattern = 'CodeCompanionChatSubmitted',
      --   group = group,
      --   callback = function(e)
      --     handles[e.data.id] = progress.handle.create({
      --       title = 'CodeCompanion',
      --       message = 'Thinking...',
      --       lsp_client = { name = e.data.adapater.formatted_name },
      --     })
      --   end
      -- })
      --
      -- vim.api.nvim_create_autocmd({ 'CodeCompanionChatStopped', 'CopeCompanionChatCleared' }, {
      --   group = group,
      --   callback = function(e)
      --     local handle = handles[e.data.id]
      --     if handle then
      --       handle.message = e.data.status == "success" and 'Done!' or 'Error!'
      --       handle:finish()
      --       handles[e.data.id] = nil
      --     end
      --   end
      -- })
    end
  },
}
