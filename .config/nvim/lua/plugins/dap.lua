return {
  "rcarriga/nvim-dap-ui",
  dependencies = {
    "mfussenegger/nvim-dap",
  },
  init = function()
    local dap = require('dap')

    vim.fn.sign_define('DapBreakpoint', {text='🛑', texthl='', linehl='', numhl=''})
    vim.fn.sign_define('DapStopped', {text='🟢', texthl='', linehl='', numhl=''})

    vim.keymap.set('n', '<F5>', dap.continue)
    vim.keymap.set('n', '<Leader>b', dap.toggle_breakpoint)
    vim.keymap.set('n', '<F10>', dap.step_over)
    vim.keymap.set('n', '<F11>', dap.step_into)
    vim.keymap.set('n', '<F12>', dap.step_out)

    --local dapui = require("dapui")
    --dap.listeners.before.attach.dapui_config = function()
    --  dapui.open()
    --end
    --dap.listeners.before.launch.dapui_config = function()
    --  dapui.open()
    --end
    --dap.listeners.before.event_terminated.dapui_config = function()
    --  dapui.close()
    --end
    --dap.listeners.before.event_exited.dapui_config = function()
    --  dapui.close()
    --end
    
    -- :h dap-launch.json
    require('dap.ext.vscode').load_launchjs(nil, {
      node = { 'typescript', 'javascript' },
      coreclr = { 'cs' },
    })

    dap.adapters.go = {
      type = 'server',
      port = '${port}',
      executable = {
        command = 'dlv',
        args = {'dap', '--listen', '127.0.0.1:${port}'},
      },
    }
  end,
}
