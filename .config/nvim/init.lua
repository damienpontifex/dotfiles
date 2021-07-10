local packer_install_path = vim.fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'

if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  os.execute('git clone https://github.com/wbthomason/packer.nvim ' .. packer_install_path)
  vim.cmd 'packadd packer.nvim'
end

require'packer'.startup(function()
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

  use { 'junegunn/fzf', run = function() vim.cmd'fzf#install()' end }
  use 'junegunn/fzf.vim'
  use 'mileszs/ack.vim'

  use 'neovim/nvim-lspconfig'
  use 'nvim-lua/completion-nvim'
  use 'hashivim/vim-terraform'
  use 'pprovost/vim-ps1'
  use 'plasticboy/vim-markdown'
  -- use 'rust-lang/rust.vim'
  -- use 'Yggdroot/indentLine'
  use 'editorconfig/editorconfig-vim'

  use 'nvim-lua/popup.nvim'
  use 'nvim-lua/plenary.nvim'
  use 'nvim-telescope/telescope.nvim'
  
  use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }

end)

vim.cmd [[
  syntax enable
  set t_ut= " without this line, weird things happen when using tmux
  
  " Enable file type detection
  filetype plugin on
  
  set t_Co=256
  
  let &grepprg='grep -n --exclude-dir={.git,node_modules,bin,obj} $* /dev/null | redraw! | cw'

  colorscheme base16-gruvbox-dark-hard
]]

