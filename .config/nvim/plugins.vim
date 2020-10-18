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

  Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
  Plug 'junegunn/fzf.vim'
  Plug 'mileszs/ack.vim'

  Plug 'neovim/nvim-lspconfig'
  Plug 'nvim-lua/completion-nvim'
  Plug 'nvim-lua/lsp-status.nvim'
	Plug 'tomasiser/vim-code-dark'
	Plug 'hashivim/vim-terraform'
	Plug 'pprovost/vim-ps1'
	Plug 'plasticboy/vim-markdown'
	Plug 'rust-lang/rust.vim'
	" Plug 'Yggdroot/indentLine'

call plug#end()
