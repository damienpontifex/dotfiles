local config_path = vim.fn.stdpath('config')
vim.cmd('source ' .. config_path .. '/plugins.vim')
vim.cmd('source ' .. config_path .. '/keyboard.vim')
vim.cmd [[
  syntax enable
  set t_ut= " without this line, weird things happen when using tmux
  
  " Enable file type detection
  filetype plugin on
  
  set t_Co=256
  
  let &grepprg='grep -n --exclude-dir={.git,node_modules,bin,obj} $* /dev/null | redraw! | cw'

  colorscheme base16-gruvbox-dark-hard
]]
vim.cmd('source ' .. config_path .. '/viminit.vim')
