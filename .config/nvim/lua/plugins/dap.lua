return {
  {
    'stevearc/overseer.nvim',
    opts = {
      dap = true,
    },
    keys = {
      { '<Leader>r', function() require('overseer').run_template() end, desc = 'Run overseer template' },
      { '<Leader>R', function() require('overseer').run_last() end,     desc = 'Run last overseer task' },
      { '<Leader>l', function() require('overseer').toggle() end,       desc = 'Toggle overseer task list' },
    },
  },
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "mfussenegger/nvim-dap-ui",
      "theHamsta/nvim-dap-virtual-text",
      { "Joakker/lua-json5", build = "./install.sh" }, -- Allows trailing comman in .vscode/launch.json
    },
    config = function(_, _opts)
      local dap = require('dap')
      local ui = require("dapui")

      vim.fn.sign_define('DapBreakpoint', { text = '🛑', texthl = '', linehl = '', numhl = '' })
      vim.fn.sign_define('DapStopped', { text = '🟢', texthl = '', linehl = '', numhl = '' })

      -- This also starts debugging, so <leader>db like leader debug
      vim.keymap.set('n', '<leader>db', dap.continue, { desc = '[DAP] Start debugging' })
      vim.keymap.set('n', '<F5>', dap.continue, { desc = '[DAP] Continue debugging' })
      vim.keymap.set('n', '<Leader>b', dap.toggle_breakpoint, { desc = '[DAP] Toggle breakpoint' })
      vim.keymap.set('n', '<Right>', dap.step_over, { desc = '[DAP] Step over' })
      vim.keymap.set('n', '<F10>', dap.step_over, { desc = '[DAP] Step over' })
      vim.keymap.set('n', '<Down>', dap.step_into, { desc = '[DAP] Step into' })
      vim.keymap.set('n', '<F11>', dap.step_into, { desc = '[DAP] Step into' })
      vim.keymap.set('n', '<Up>', dap.step_out, { desc = '[DAP] Step out' })
      vim.keymap.set('n', '<F12>', dap.step_out, { desc = '[DAP] Step out' })

      dap.listeners.before.attach.dapui_config = function()
        ui.open()
      end
      dap.listeners.before.launch.dapui_config = function()
        ui.open()
      end
      dap.listeners.before.event_terminated.dapui_config = function()
        ui.close()
      end
      dap.listeners.before.event_exited.dapui_config = function()
        ui.close()
      end

      -- :h dap-launch.json
      require('dap.ext.vscode').json_decode = require('json5').parse
      require('dap.ext.vscode').load_launchjs(nil, {
        node = { 'typescript', 'javascript' },
        coreclr = { 'cs' },
      })

      -- So comletions in the dap-repl work automatically
      -- au FileType dap-repl lua require('dap.ext.autocompl').attach()
    end,
  }
}
