return {
  {
    'github/copilot.vim',
    event = 'InsertEnter',
    init = function()
      vim.api.nvim_set_keymap('i', '<M-CR>', 'copilot#Accept("<CR>")', { expr = true, noremap = true, silent = true })
      vim.g.copilot_no_tab_map = true
      vim.g.copilot_workspace_folders = { vim.fn.getcwd() }
      -- Only accept one line at a time
      -- vim.keymap.set('i', '<Tab>', 'copilot#AcceptLine()', { expr = true, replace_keycodes = false, })
    end,
  },
}
