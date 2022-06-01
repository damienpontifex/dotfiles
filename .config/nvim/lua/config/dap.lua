local M = {}

-- Useful page of adapters
-- https://github.com/mfussenegger/nvim-dap/wiki/Debug-Adapter-installation

function M.setup_node(dap)
  dap.adapters.node = {
    type = 'executable',
    command = 'node',
    args = { 
      vim.fn.stdpath('data')..'/vscode-node-debug2/out/src/nodeDebug.js',
    }
  }
  dap.adapters.javsacript = dap.adapters.node
  dap.adapters.typescript = dap.adapters.node

  dap.configurations.javascript = {
    {
      type = 'node',
      request = 'launch',
      name = "Launch program",
      program = '${file}',
    },
    {
      -- For this to work you need to make sure the node process is started with the `--inspect` flag.
      name = 'Attach to process',
      type = 'node',
      request = 'attach',
      processId = require('dap.utils').pick_process,
    },
  }


  --dap.adapters.node = function(cb, config)
  --  if config.request == 'attach' then
  --    --local install_path = fn.stdpath('data')..'vscode-node-debug2'
  --    --if fn.empty(fn.glob(install_path)) > 0 then
  --    --  node2_bootstrap = fn.system({'git', 'clone', '--depth', '1', 'https://github.com/microsoft/vscode-node-debug2.git', install_path})
  --    --  -- npm install 
  --    --  -- npm run build
  --    --end
  --    cb({
  --      type = 'server',
  --      port = 9229,
  --      host = '127.0.0.1',
  --    })
  --  else
  --    -- launch
  --  end
  --end

  ----if opts and opts.include_configs then
  --  dap.configurations.node = dap.configurations.node or {}
  --  print('inserting')
  --  table.insert(dap.configurations.node, {
  --    type = 'node',
  --    request = 'launch',
  --    name = 'Launch file',
  --    program = '${file}',
  --  })
  --  table.insert(dap.configurations.node, {
  --    type = 'node',
  --    request = 'attach',
  --    name = 'Attach',
  --  })
  ----end
end

function M.setup_rust(dap)
  dap.adapters.lldb = {
    type = 'executable',
    command = '/usr/bin/lldb-vscode',
    name = 'lldb'
  }

  dap.configurations.cpp = {
    {
      name = 'Launch',
      type = 'lldb',
      request = 'launch',
      program = function()
        return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
      end,
      cwd = '${workspaceFolder}',
      stopOnEntry = false,
      args = {},

      -- 💀
      -- if you change `runInTerminal` to true, you might need to change the yama/ptrace_scope setting:
      --
      --    echo 0 | sudo tee /proc/sys/kernel/yama/ptrace_scope
      --
      -- Otherwise you might get the following error:
      --
      --    Error on launch: Failed to attach to the target process
      --
      -- But you should be aware of the implications:
      -- https://www.kernel.org/doc/html/latest/admin-guide/LSM/Yama.html
      -- runInTerminal = false,
    },
  }

  dap.configurations.c = dap.configurations.cpp
  dap.configurations.rust = dap.configurations.cpp
  dap.configurations.rust[1].program = function()
    local likely_executable_name = string.gsub(vim.fn.getcwd(), '(.*/)(.*)', '%2')
    return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/target/debug/' .. likely_executable_name, 'file')
  end
end

function M.setup_ui(dap)
  local dapui = require('dapui')
  dapui.setup()
  
  -- Automatically setup dapui with dap eevents
  dap.listeners.after.event_initialized["dapui_config"] = function()
    dapui.open()
  end
  dap.listeners.before.event_terminated["dapui_config"] = function()
    dapui.close()
  end
  dap.listeners.before.event_exited["dapui_config"] = function()
    dapui.close()
  end

end

function M.setup()

  local dap = require('dap')
  vim.fn.sign_define('DapBreakpoint', {text='🛑', texthl='', linehl='', numhl=''})
  vim.fn.sign_define('DapStopped', {text='🟢', texthl='', linehl='', numhl=''})

  M.setup_ui(dap)

  require("nvim-dap-virtual-text").setup()

  require('telescope').load_extension('dap')
  require('dap-python').setup()

  M.setup_node(dap)

  M.setup_rust(dap)

  vim.keymap.set('n', '<F5>', function()
    --print('attaching')
    dap.continue()
  end, nil)
  vim.keymap.set('n', '<Leader>b', dap.toggle_breakpoint)
  vim.keymap.set('n', '<F10>', dap.step_over)
  vim.keymap.set('n', '<F11>', dap.step_into)
  vim.keymap.set('n', '<F12>', dap.step_out)
  --nnoremap <silent> <Leader>b <Cmd>lua require'dap'.toggle_breakpoint()<CR>
  --nnoremap <silent> <Leader>B <Cmd>lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>
  --nnoremap <silent> <Leader>lp <Cmd>lua require'dap'.set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<CR>
  --nnoremap <silent> <Leader>dr <Cmd>lua require'dap'.repl.open()<CR>
  --nnoremap <silent> <Leader>dl <Cmd>lua require'dap'.run_last()<CR>

  -- :h dap-launch.json
  require('dap.ext.vscode').load_launchjs(nil, {
    node = { 'typescript', 'javascript' },
  })
end

return M

