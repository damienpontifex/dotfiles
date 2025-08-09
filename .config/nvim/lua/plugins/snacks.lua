return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  init = function()
    vim.api.nvim_create_autocmd("User", {
      pattern = "OilActionsPost",
      callback = function(event)
        if event.data.actions.type == "move" then
          Snacks.rename.on_rename_file(event.data.actions.src_url, event.data.actions.dest_url)
        end
      end,
    })
  end,
  keys = {
    { "<leader>bd", function() Snacks.bufdelete() end,        desc = "Buffer delete",        mode = "n" },
    { "<leader>ba", function() Snacks.bufdelete.all() end,    desc = "Buffer delete all",    mode = "n" },
    { "<leader>bo", function() Snacks.bufdelete.other() end,  desc = "Buffer delete other",  mode = "n" },
    { "<leader>bz", function() Snacks.zen() end,              desc = "Toggle Zen Mode",      mode = "n" },
    -- { "<C-b>",      function() Snacks.explorer() end,         desc = "Toggle Snacks Explorer", mode = "n" },
    { "<leader>gg", function() Snacks.lazygit() end,          desc = "Toggle LazyGit",       mode = "n" },
    { "<leader>gb", function() Snacks.git.blame_line() end,   desc = "Git blame line",       mode = "n" },
    { "<leader>gB", function() Snacks.gitbrowse() end,        desc = "Git Browse",           mode = "n" },
    { "<leader>gf", function() Snacks.lazygit.log_file() end, desc = "Lazygit current file", mode = "n" },
    { "<leader>gl", function() Snacks.lazygit.log() end,      desc = "Lazygit log (cwd)",    mode = "n" },
    { "<c-/>",      function() Snacks.terminal() end,         desc = "Toggle terminal",      mode = "n" },
    { "<c-_>",      function() Snacks.terminal() end,         desc = "which_key_ignore",     mode = "n" },
    -- { "<C-f>", "<cmd>SnacksTogglePicker<cr>",                desc = "Toggle Snacks Picker", mode = "n" },
    -- { "<C-s>", "<cmd>SnacksToggleScope<cr>",                 desc = "Toggle Snacks Scope",  mode = "n" },
    -- { "<C-n>", "<cmd>SnacksToggleNotifier<cr>",              desc = "Toggle Snacks Notifier", mode = "n" },
    -- { "<C-q>", "<cmd>SnacksQuickFile<cr>",                   desc = "Snacks Quick File",    mode = "n" },
  },
  opts = {
    bigfile = { enabled = true },
    dashboard = { enabled = false },
    explorer = { enabled = false },
    indent = { enabled = true },
    input = { enabled = false },
    picker = {
      enabled = true,
      hidden = true,
      ignored = true,
      excluded = { 'node_modules', '.git', '.cache', '.DS_Store' },
    },
    notifier = { enabled = false },
    quickfile = { enabled = true },
    scope = { enabled = false },
    statuscolumn = { enabled = false },
    words = { enabled = false },
    rename = { enabled = true },
    lazygit = { enabled = true },
    zen = {
      enabled = true,
      toggles = {
        ufo             = true,
        dim             = true,
        git_signs       = false,
        diagnostics     = false,
        line_number     = false,
        relative_number = false,
        signcolumn      = "no",
        indent          = false
      }
    },
  },
  config = function(_, opts)
    require("snacks").setup(opts)

    Snacks.toggle.new({
      id = "ufo",
      name = "Enable/Disable ufo",
      get = function()
        return require("ufo").inspect()
      end,
      set = function(state)
        if state == nil then
          require("noice").enable()
          require("ufo").enable()
          vim.o.foldenable = true
          vim.o.foldcolumn = "1"
        else
          require("noice").disable()
          require("ufo").disable()
          vim.o.foldenable = false
          vim.o.foldcolumn = "0"
        end
      end,
    })
  end
}
