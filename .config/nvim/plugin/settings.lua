local opt = vim.opt
local g = vim.g

vim.cmd [[
  syntax enable
  set t_ut= " without this line, weird things happen when using tmux

  " Enable file type detection
  filetype plugin on

  set t_Co=256

  let &grepprg='grep -n --exclude-dir={.git,node_modules,bin,obj} $* /dev/null | redraw! | cw'
]]
-- ??TODO: vim.opt.guifont = ''
opt.autoindent = true -- maintain indent of current line
opt.autoread = true
opt.backspace = 'indent,eol,start' -- allow unrestricted backspacing in insert mode
opt.backup = false -- don't make backups before writing
opt.belloff = 'all' -- never ring the bell for any reason
opt.cindent = true
opt.clipboard = 'unnamed' -- Use OS clipboard
opt.completeopt = 'menuone' -- show menu even if there is only one candidate
opt.completeopt:append { 'noselect' } -- don't automatically select candidate
opt.cursorline = true -- highlight current line
opt.emoji = false -- don't assume all emoji are double width
opt.errorbells = false
opt.expandtab = true -- always use spaces instead of tabs
opt.foldlevelstart = 99 -- start unfolded
opt.foldmethod = 'syntax'
opt.hidden = true
opt.hlsearch = true
opt.ignorecase = true
opt.inccommand = 'nosplit' -- highlight and substitute while you type
opt.incsearch = true
opt.mouse = 'a' -- Enable mouse
opt.number = true -- show line numbers in gutter
opt.path:append { '**' } -- recursive find/search
opt.relativenumber = true -- show line number relative to the cursor line
opt.scrolloff = 8 -- keep this number of lines visible above/below the cursor when scrolling
opt.sessionoptions = 'buffers,tabpages,winsize'
opt.shiftwidth = 2 -- Number of spaces for each >> or << indent shift
opt.showmatch = true -- highlight matching [()}]
opt.sidescrolloff = 8
opt.smartcase = true
opt.smarttab = true
opt.splitbelow = true
opt.splitright = true
opt.swapfile = false
opt.tabstop = 2 -- Number of visual spaces per TAB
opt.termguicolors = true -- use guifg/guibg instead of ctermfg/ctermbg in terminal
opt.updatetime = 300 -- smaller updatetime for CurshorHold & CursorHoldI
opt.visualbell = false
opt.wildignore:append { '*/node_modules/*', '*/bin/*', '*/obj/*' }
opt.wildmenu = true -- show options as list when switching buffers etc
opt.wrap = false
opt.conceallevel = 0 -- never conceal

-- g.mapleader = ' '
-- g.maplocalleader = ' '

-- Highlight on yank
vim.api.nvim_create_autocmd({ "TextYankPost" }, {
  callback = function()
    vim.highlight.on_yank({ higroup = "Visual", timeout = 200 })
  end,
})
