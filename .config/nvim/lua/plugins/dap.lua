return {
  "mfussenegger/nvim-dap",
  dependencies = {
    "mfussenegger/nvim-dap-ui",
    "theHamsta/nvim-dap-virtual-text",
    { "Joakker/lua-json5", build = "./install.sh" }, -- Allows trailing comman in .vscode/launch.json
  },
  config = function()
    local dap = require('dap')
    local ui = require("dapui")

    vim.fn.sign_define('DapBreakpoint', { text = '🛑', texthl = '', linehl = '', numhl = '' })
    vim.fn.sign_define('DapStopped', { text = '🟢', texthl = '', linehl = '', numhl = '' })

    vim.keymap.set('n', '<F5>', dap.continue)
    vim.keymap.set('n', '<Leader>b', dap.toggle_breakpoint)
    vim.keymap.set('n', '<Right>', dap.step_over)
    vim.keymap.set('n', '<F10>', dap.step_over)
    vim.keymap.set('n', '<Down>', dap.step_into)
    vim.keymap.set('n', '<F11>', dap.step_into)
    vim.keymap.set('n', '<Up>', dap.step_out)
    vim.keymap.set('n', '<F12>', dap.step_out)

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
