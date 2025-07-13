return {
  {
    'stevearc/overseer.nvim',
    lazy = false,
    opts = {
      dap = true,
      strategy = { 'terminal', use_shell = true },
    },
    keys = {
      { '<Leader>r', function() require('overseer').run_template() end, desc = 'Run overseer template' },
      { '<Leader>R', function() require('overseer').run_last() end,     desc = 'Run last overseer task' },
      { '<Leader>t', function() require('overseer').toggle() end,       desc = 'Toggle overseer task list' },
    },
  },
  {
    "rcarriga/nvim-dap-ui",
    event = "VimEnter",
    dependencies = {
      "mfussenegger/nvim-dap",
      "theHamsta/nvim-dap-virtual-text",
      "nvim-neotest/nvim-nio",
      { "Joakker/lua-json5", build = "./install.sh" }, -- Allows trailing comman in .vscode/launch.json
    },
    config = function(_, opts)
      local dap, dapui = require('dap'), require('dapui')
      dapui.setup(opts)

      -- dap.set_log_level('TRACE')

      vim.fn.sign_define('DapBreakpoint', { text = '🛑', texthl = '', linehl = '', numhl = '' })
      vim.fn.sign_define('DapStopped', { text = '🟢', texthl = '', linehl = '', numhl = '' })

      -- This also starts debugging, so <leader>db like leader debug
      vim.keymap.set('n', '<leader>db', dapui.toggle, { desc = '[DAP] Start debugging' })
      vim.keymap.set('n', '<F5>', dap.continue, { desc = '[DAP] Continue debugging' })
      vim.keymap.set('n', '<Leader>b', dap.toggle_breakpoint, { desc = '[DAP] Toggle breakpoint' })
      vim.keymap.set('n', '<Right>', dap.step_over, { desc = '[DAP] Step over' })
      vim.keymap.set('n', '<F10>', dap.step_over, { desc = '[DAP] Step over' })
      vim.keymap.set('n', '<Down>', dap.step_into, { desc = '[DAP] Step into' })
      vim.keymap.set('n', '<F11>', dap.step_into, { desc = '[DAP] Step into' })
      vim.keymap.set('n', '<Up>', dap.step_out, { desc = '[DAP] Step out' })
      vim.keymap.set('n', '<F12>', dap.step_out, { desc = '[DAP] Step out' })

      dap.listeners.before.attach.dapui_config = function()
        dapui.open()
      end
      dap.listeners.before.launch.dapui_config = function()
        dapui.open()
      end
      -- dap.listeners.before.event_terminated.dapui_config = function(body)
      --   -- print(vim.inspect(body))
      --   dapui.close()
      -- end
      -- dap.listeners.before.event_exited.dapui_config = function()
      --   dapui.close()
      -- end

      -- Allows trailing commas in launch.json files
      require('dap.ext.vscode').json_decode = require('json5').parse
      -- :h dap-launch.json
      require('dap.ext.vscode').load_launchjs(nil, {
        node = { 'typescript', 'javascript' },
        coreclr = { 'cs' },
      })

      -- So comletions in the dap-repl work automatically
      -- au FileType dap-repl lua require('dap.ext.autocompl').attach()

      dap.adapters.node = {
        type = 'executable',
        command = 'js-debug-adapter',
      }
      dap.adapters.javsacript = dap.adapters.node
      dap.adapters.typescript = dap.adapters.node

      dap.adapters.lldb = {
        type = 'executable',
        command = 'codelldb',
        name = 'lldb',
      }

      dap.adapters.debugpy = {
        type = 'executable',
        command = 'debugpy-adapter',
      }
    end,
  }
}
