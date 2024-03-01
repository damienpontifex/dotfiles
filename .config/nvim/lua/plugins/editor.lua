return {
  -- file explorer
  {
    "nvim-neo-tree/neo-tree.nvim",
    event = 'VeryLazy',
    keys = {
      { "<C-b>", "<cmd>Neotree toggle reveal<CR>", desc = "Toggle" }
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
      "MunifTanjim/nui.nvim",
      -- "3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
    },
  },

  -- fuzzy finder
  {
    'nvim-telescope/telescope.nvim',
    cmd = "Telescope",
    version = false,  -- telescope did only one release, so use HEAD for now
    keys = {
      { 
        '<C-p>',
        function() 
          require('telescope.builtin').find_files() 
        end,
        desc = 'Find files' 
      },
      { 
        '<C-f>',
        function() require('telescope.builtin').live_grep() end,
        desc = 'Grep' 
      },
      { 
        '<Leader>gf',
        function() require('telescope.builtin').git_files() end,
        desc = 'Git files' 
      },
      {
        '<Leader>fg', 
        function() require('telescope.builtin').live_grep() end,
        desc = 'Grep'
      },
      {
        '<Leader>fb', 
        function() require('telescope.builtin').buffers() end,
        desc = 'Find buffers'
      },
      {
        '<Leader>fc',
        function() require('telescope.builtin').commands() end,
        desc = 'Find commands'
      },
      {
        '<Leader>fh',
        function() require('telescope.builtin').help_tags() end,
        desc = 'Find tags'
      },
      {
        '<Leader>gs',
        function() require('telescope.builtin').git_status() end,
        desc = 'Git status'
      },
      { 
        '<C-t>', 
        function() 
          require('telescope.builtin').lsp_dynamic_workspace_symbols() 
        end, 
        desc = 'LSP workspace symbols' 
      },
    },
    dependencies = {
      'nvim-lua/popup.nvim',
      'nvim-lua/plenary.nvim',
      'nvim-telescope/telescope-live-grep-raw.nvim',
    },
    opts = {
      defaults = {
        theme = "center",
        sorting_strategy = "ascending",
        layout_config = {
          horizontal = {
            prompt_position = "top",
            preview_width = 0.3,
          },
        },
        mappings = {
          i = {
            -- ["<esc>"] = require('telescope.actions').close
          },
        },
      },
    },

    --   local is_inside_work_tree = {}
    --   -- git_files if in git directory, otherwise find_files
    --   vim.keymap.set('n', '<C-p>', function()
    --     local opts = {} -- define here if you want to define something

    --     local cwd = vim.fn.getcwd()
    --     if is_inside_work_tree[cwd] == nil then
    --       vim.fn.system("git rev-parse --is-inside-work-tree")
    --       is_inside_work_tree[cwd] = vim.v.shell_error == 0
    --     end

    --     if is_inside_work_tree[cwd] then
    --       builtin.git_files(opts)
    --     else
    --       builtin.find_files(opts)
    --     end
    --   end, opts)
    --   require('telescope').load_extension('live_grep_args')
    --   vim.keymap.set('n', '<C-f>', require('telescope').extensions.live_grep_args.live_grep_args, opts)

    --   vim.keymap.set('n', 'gD', function()
    --     builtin.lsp_definitions({ jump_type = 'vsplit' })
    --   end, opts)
  }
}
