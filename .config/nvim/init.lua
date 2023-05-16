local fn = vim.fn
local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
  packer_bootstrap = fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
end

vim.filetype.add({
  extension = {
    bicep = "bicep",
    gotmpl = "yaml",
  }
})


require'packer'.startup(function(use)
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'

  use {
    'nvim-telescope/telescope.nvim',
    config = function()
      require('config.telescope').setup()
    end,
    requires = {
      'nvim-lua/popup.nvim',
      'nvim-lua/plenary.nvim',
      'nvim-telescope/telescope-live-grep-raw.nvim',
    }
  }

  use {
    'scrooloose/nerdtree',
    config = function() 
      require('config.nerdtree').setup()
    end,
  }

  use 'ryanoasis/vim-devicons'
  use 'tpope/vim-fugitive'
  use {
    'vim-airline/vim-airline',
    requires = {
      'vim-airline/vim-airline-themes',
    },
  }

  use {
    'numToStr/Comment.nvim',
    config = function()
      require('Comment').setup()
    end
  }

  -- Themes
  use {
   'vv9k/vim-github-dark',
   config = function()
     vim.cmd 'colorscheme ghdark'
     -- set hlsearch " highlight matches
     -- See :h cterm-colors for colours
     -- vim.cmd 'autocmd ColorScheme * highlight Search ctermbg=LightBlue ctermfg=Black'
   end,
  }

  use {
    "neovim/nvim-lspconfig",
    config = function()
      require('config.lsp').setup()
    end,
    -- wants = { "cmp-nvim-lsp" },
    requires = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "Hoffs/omnisharp-extended-lsp.nvim",
    }
  }

  use { 
    'hrsh7th/nvim-cmp',
    config = function()
      require('config.cmp').setup()
    end,
    requires = {
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-nvim-lua',
      'hrsh7th/cmp-emoji',
      'hrsh7th/cmp-nvim-lsp-signature-help',
      'L3MON4D3/LuaSnip',
      'saadparwaiz1/cmp_luasnip',
    }
  }

  -- use {
  --   'simrat39/rust-tools.nvim',
  --   config = function()
  --     require('config.rusttools').setup()
  --   end,
  --   requires = {
  --     'mfussenegger/nvim-dap',
  --     'nvim-lua/plenary.nvim',
  --   }
  -- }
  use { 
    'rcarriga/nvim-dap-ui', 
    config = function()
      require('config.dap').setup()
    end,
    requires = {
      'mfussenegger/nvim-dap',
      'mfussenegger/nvim-dap-python',
      'theHamsta/nvim-dap-virtual-text',
      'nvim-telescope/telescope-dap.nvim'
    } 
  }

  -- Languages
  use 'hashivim/vim-terraform'
  use 'pprovost/vim-ps1'
  use 'plasticboy/vim-markdown'
  use 'jparise/vim-graphql'

  use { 
    'nvim-treesitter/nvim-treesitter',
    config = function()
      require('config.treesitter').setup()
    end,
    run = ':TSUpdate' 
  }

  -- Automatically set up your configuration after cloning packer.nvim
  if packer_bootstrap then
    require('packer').sync()
  end

end)

