local fn = vim.fn
local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
  packer_bootstrap = fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
end

require'packer'.startup(function(use)
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'

  use 'scrooloose/nerdtree'
  use 'ryanoasis/vim-devicons'
  -- use 'tiagofumo/vim-nerdtree-syntax-highlight'
  use 'tpope/vim-fugitive'

  use 'tomasiser/vim-code-dark'
  use 'arcticicestudio/nord-vim'
  -- use 'morhetz/gruvbox'
  use 'chriskempson/base16-vim'
  use 'vim-airline/vim-airline'
  -- use "projekt0n/github-nvim-theme"
  use 'vv9k/vim-github-dark'

  -- use { 'junegunn/fzf', run = 'call fzf#install()' }
  -- use 'junegunn/fzf.vim'
  -- use 'mileszs/ack.vim'

  use 'neovim/nvim-lspconfig'
  use 'nvim-lua/completion-nvim'
  use 'hashivim/vim-terraform'
  use 'pprovost/vim-ps1'
  use 'plasticboy/vim-markdown'
  -- use 'rust-lang/rust.vim'
  -- use 'Yggdroot/indentLine'
  use 'editorconfig/editorconfig-vim'

  use {
    'nvim-telescope/telescope.nvim',
    requires = {{'nvim-lua/popup.nvim'}, {'nvim-lua/plenary.nvim'}}
  }

  use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }

  -- Automatically set up your configuration after cloning packer.nvim
  if packer_bootstrap then
    require('packer').sync()
  end

end)

vim.cmd [[
  syntax enable
  set t_ut= " without this line, weird things happen when using tmux

  " Enable file type detection
  filetype plugin on

  set t_Co=256

  let &grepprg='grep -n --exclude-dir={.git,node_modules,bin,obj} $* /dev/null | redraw! | cw'

  colorscheme ghdark
]]

