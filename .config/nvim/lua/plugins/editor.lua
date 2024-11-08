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
    event = 'VimEnter',
    version = false,  -- telescope did only one release, so use HEAD for now
    keys = {
      { 
        '<C-p>',
        function() require('telescope.builtin').find_files() end,
        desc = 'Find files' 
      },
      { 
        '<C-f>',
        function() require('telescope.builtin').live_grep() end,
        desc = 'Grep' 
      },
      {
        '<Leader>fg', 
        function() require('telescope.builtin').live_grep() end,
        desc = 'Grep'
      },
      { 
        '<Leader>gf',
        function() require('telescope.builtin').git_files() end,
        desc = '[G]it [F]iles' 
      },
      {
        '<Leader>fb', 
        function() require('telescope.builtin').buffers() end,
        desc = 'Find buffers'
      },
      {
        '<Leader>fc',
        function() require('telescope.builtin').commands() end,
        desc = '[F]ind [C]ommands'
      },
      {
        '<Leader>fk',
        function() require('telescope.builtin').keymaps() end,
        desc = '[F]ind [K]eymaps'
      },
      {
        '<Leader>fh',
        function() require('telescope.builtin').help_tags() end,
        desc = '[F]ind [H]elp'
      },
      {
        '<Leader>gs',
        function() require('telescope.builtin').git_status() end,
        desc = '[G]it [S]tatus'
      },
      {
        '<C-t>',
        function() require('telescope.builtin').lsp_dynamic_workspace_symbols() end, 
        desc = 'LSP workspace symbols' 
      },
    },
    dependencies = {
      'nvim-lua/plenary.nvim',
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
  },
  {
    'Mofiqul/vscode.nvim',
    lazy = false,
    config = function()
      vim.cmd.colorscheme 'vscode'
    end,
  },
  {
    'vim-airline/vim-airline',
    dependencies = {
      'vim-airline/vim-airline-themes',
    },
    config = function()
      vim.g.airline_theme = 'deus'
    end,
  },
  -- Highlight todo, notes, etc in comments
  { 
    'folke/todo-comments.nvim',
    event = 'VimEnter',
    dependencies = { 'nvim-lua/plenary.nvim' },
    opts = { signs = false } 
  },

  -- This is what powers LazyVim's fancy-looking
  -- tabs, which include filetype icons and close buttons.
  {
    "akinsho/bufferline.nvim",
    event = "VeryLazy",
    keys = {
      { "<leader>bp", "<Cmd>BufferLineTogglePin<CR>", desc = "Toggle pin" },
      { "<leader>bP", "<Cmd>BufferLineGroupClose ungrouped<CR>", desc = "Delete non-pinned buffers" },
      { "<leader>bo", "<Cmd>BufferLineCloseOthers<CR>", desc = "Delete other buffers" },
      { "<leader>br", "<Cmd>BufferLineCloseRight<CR>", desc = "Delete buffers to the right" },
      { "<leader>bl", "<Cmd>BufferLineCloseLeft<CR>", desc = "Delete buffers to the left" },
      { "<S-h>", "<cmd>BufferLineCyclePrev<cr>", desc = "Prev buffer" },
      { "<S-l>", "<cmd>BufferLineCycleNext<cr>", desc = "Next buffer" },
      { "[b", "<cmd>BufferLineCyclePrev<cr>", desc = "Prev buffer" },
      { "]b", "<cmd>BufferLineCycleNext<cr>", desc = "Next buffer" },
    },
    opts = {
      options = {
        -- stylua: ignore
        close_command = function(n) vim.api.nvim_buf_delete(n, { force = false }) end,
        -- stylua: ignore
        right_mouse_command = function(n) vim.api.nvim_buf_delete(n, { force = false }) end,
        diagnostics = "nvim_lsp",
        always_show_bufferline = false,
        diagnostics_indicator = function(_, _, diag)
          local icons = {
            Error = " ",
            Warn  = " ",
            Hint  = " ",
            Info  = " ",
          }
          local ret = (diag.error and icons.Error .. diag.error .. " " or "")
          .. (diag.warning and icons.Warn .. diag.warning or "")
          return vim.trim(ret)
        end,
        offsets = {
          {
            filetype = "neo-tree",
            text = "Neo-tree",
            highlight = "Directory",
            text_align = "left",
          },
        },
      },
    },
    config = function(_, opts)
      require("bufferline").setup(opts)
      -- Fix bufferline when restoring a session
      vim.api.nvim_create_autocmd("BufAdd", {
        callback = function()
          vim.schedule(function()
            pcall(nvim_bufferline)
          end)
        end,
      })
    end,
  },
}
