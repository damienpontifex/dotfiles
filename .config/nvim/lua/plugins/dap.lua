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

      vim.fn.sign_define('DapBreakpoint', { text = '●', texthl = '', linehl = '', numhl = '' })
      vim.fn.sign_define('DapStopped', { text = '▶️', texthl = '', linehl = '', numhl = '' })

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

      dap.adapters.netcoredbg = {
        type = 'executable',
        command = 'netcoredbg',
        args = { '--interpreter=vscode' },
      }
      dap.adapters.coreclr = dap.adapters.netcoredbg

      dap.configurations.cs = { {
        type = 'coreclr',
        name = 'Debug .NET Core',
        request = 'launch',
        -- preLaunchTask = 'build',
        program = function()
          local csproj_files = vim.fn.glob('**/*.csproj', false, true)
          if #csproj_files == 0 then
            vim.notify('No .csproj files found in the current directory.', vim.log.levels.WARN)
            return nil
          end

          local project_to_run
          if #csproj_files == 1 then
            project_to_run = csproj_files[1]
          end
          if #csproj_files > 1 then
            local projects = {}
            for _, project in ipairs(csproj_files) do
              local project_name = vim.fn.fnamemodify(project, ':t:r')
              projects[project_name] = project
            end
            vim.ui.select(projects, {
              prompt = 'Select a .csproj file:',
              format_item = function(item)
                return item
              end,
            }, function(selected_project)
              if selected_project then
                project_to_run = selected_project
              end
            end)
          end
          print(project_to_run)

          local project_dir = vim.fn.fnamemodify(project_to_run, ':p:h')
          local debug_path = project_dir .. '/bin/Debug'
          local target_frameworks = vim.fn.glob(debug_path .. '/net*', true, true)
          local target_framework
          if #target_frameworks == 0 then
            vim.notify('No target frameworks found in ' .. debug_path, vim.log.levels.WARN)
            return nil
          elseif #target_frameworks == 1 then
            target_framework = vim.fn.fnamemodify(target_frameworks[1], ':t')
          else -- multiple target frameworks
            vim.ui.select(target_frameworks, {
              prompt = 'Select target framework:',
              format_item = function(item)
                return vim.fn.fnamemodify(item, ':t')
              end,
            }, function(selected_framework)
              if selected_framework then
                target_framework = selected_framework
              end
            end)
          end
          local debug_dll = debug_path ..
              '/' .. target_framework .. '/' .. vim.fn.fnamemodify(project_to_run, ':t:r') .. '.dll'
          return debug_dll
        end,
      } }
    end
  }
}
