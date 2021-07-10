if !filereadable(expand("$HOME/.local/share/nvim/site/autoload/plug.vim"))
  call system(expand("sh -c 'curl -fLo $HOME/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'"))
endif

call plug#begin('~/.vim/plugged')
  Plug 'scrooloose/nerdtree'
  " Plug 'ryanoasis/vim-devicons'
  " Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
  Plug 'tpope/vim-fugitive'

  Plug 'tomasiser/vim-code-dark'
  Plug 'arcticicestudio/nord-vim'
  " Plug 'morhetz/gruvbox'
  Plug 'chriskempson/base16-vim'
  Plug 'vim-airline/vim-airline'

  Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
  Plug 'junegunn/fzf.vim'
  Plug 'mileszs/ack.vim'

  Plug 'neovim/nvim-lspconfig'
  Plug 'nvim-lua/completion-nvim'
  Plug 'hashivim/vim-terraform'
  Plug 'pprovost/vim-ps1'
  Plug 'plasticboy/vim-markdown'
  " Plug 'rust-lang/rust.vim'
  " Plug 'Yggdroot/indentLine'
  Plug 'editorconfig/editorconfig-vim'

  Plug 'nvim-lua/popup.nvim'
  Plug 'nvim-lua/plenary.nvim'
  Plug 'nvim-telescope/telescope.nvim'
  
  Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

call plug#end()

