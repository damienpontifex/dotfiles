local fn = vim.fn
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

vim.filetype.add({
  extension = {
    bicep = "bicep",
    gotmpl = "yaml",
  }
})

require('config.options')
require('config.autocmds')
require('config.keymaps')

require('lazy').setup('plugins', {
  change_detection = {
    notify = false,
  },
})

--   -- git
--   {
--     'tpope/vim-fugitive',
--     config = function()
--       require('config.fugitive').setup()
--     end,
--   }
--   {
--     'lewis6991/gitsigns.nvim',
--     config = function()
--       require('config.gitsigns').setup()
--     end,
--   }
--   -- {
--   --   'simrat39/rust-tools.nvim',
--   --   config = function()
--   --     require('config.rusttools').setup()
--   --   end,
--   --   dependencies = {
--   --     'mfussenegger/nvim-dap',
--   --     'nvim-lua/plenary.nvim',
--   --   }
--   -- }
--   { 
--     'rcarriga/nvim-dap-ui', 
--     config = function()
--       require('config.dap').setup()
--     end,
--     dependencies = {
--       'mfussenegger/nvim-dap',
--       'mfussenegger/nvim-dap-python',
--       'theHamsta/nvim-dap-virtual-text',
--       'nvim-telescope/telescope-dap.nvim'
--     } 
--   }
--

