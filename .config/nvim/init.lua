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

-- Autocommand that reloads neovim whenever you save this file
-- local mygroup = vim.api.nvim_create_augroup('packer_user_config', { clear = true })
-- vim.api.nvim_create_autocmd({ "BufWritePost" }, {
--   pattern = {"plugins.lua"},
--   command = "source <afile> | LazyInstall",
-- })

vim.filetype.add({
  extension = {
    bicep = "bicep",
    gotmpl = "yaml",
  }
})

require('lazy').setup('plugins')

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
--   {
--     'vim-airline/vim-airline',
--     dependencies = {
--       'vim-airline/vim-airline-themes',
--     },
--     config = function()
--       vim.g.airline_theme = 'catppuccin'
--     end,
--   }
--
--   {
--     'numToStr/Comment.nvim',
--     config = function()
--       require('Comment').setup()
--     end
--   }
--
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
--   -- Languages
--   'hashivim/vim-terraform'
--   'pprovost/vim-ps1'
--   'plasticboy/vim-markdown'
--   'jparise/vim-graphql'
--   'towolf/vim-helm'
--
--   { 
--     'nvim-treesitter/nvim-treesitter',
--     config = function()
--       require('config.treesitter').setup()
--     end,
--     run = ':TSUpdate' 
--   }
-- })

