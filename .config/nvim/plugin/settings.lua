-- ??TODO: vim.opt.guifont = ''
vim.opt.autoindent = true -- maintain indent of current line
vim.opt.autoread = true -- atuo reload file if changed on disk
vim.opt.backspace = 'indent,eol,start' -- allow unrestricted backspacing in insert mode
vim.opt.backup = false -- don't make backups before writing
vim.opt.belloff = 'all' -- never ring the bell for any reason
vim.opt.cindent = true
vim.opt.clipboard = 'unnamed' -- Use OS clipboard
vim.opt.colorcolumn = '80'
vim.opt.completeopt = 'menuone' -- show menu even if there is only one candidate
vim.opt.completeopt:append { 'noselect' } -- don't automatically select candidate
vim.opt.cursorline = true -- highlight current line
vim.opt.emoji = false -- don't assume all emoji are double width
vim.opt.errorbells = false
vim.opt.expandtab = true -- always use spaces instead of tabs
vim.opt.foldlevelstart = 99 -- start unfolded
vim.opt.foldmethod = 'syntax'
vim.opt.hidden = true -- Allows you to hide buffers with unsaved changes without being prompted
vim.opt.hlsearch = true -- higlight matches of search
vim.opt.ignorecase = true
vim.opt.inccommand = 'nosplit' -- highlight and substitute while you type
vim.opt.incsearch = true
vim.opt.mouse = 'a' -- Enable mouse
vim.opt.number = true -- show line numbers in gutter
vim.opt.path:append { '**' } -- recursive find/search
vim.opt.relativenumber = true -- show line number relative to the cursor line
vim.opt.scrolloff = 8 -- keep this number of lines visible above/below the cursor when scrolling
vim.opt.sessionoptions = 'buffers,tabpages,winsize'
vim.opt.shiftwidth = 2 -- Number of spaces for each >> or << indent shift
vim.opt.showmatch = true -- highlight matching [()}]
vim.opt.sidescrolloff = 8
vim.opt.smartcase = true
vim.opt.smarttab = true
vim.opt.splitbelow = true -- open horizontal splits below current window
vim.opt.splitright = true -- open vertical splits to the right of current window
vim.opt.swapfile = false
vim.opt.tabstop = 2 -- Number of visual spaces per TAB
vim.opt.termguicolors = true -- use guifg/guibg instead of ctermfg/ctermbg in terminal
vim.opt.updatetime = 300 -- smaller updatetime for CurshorHold & CursorHoldI
vim.opt.visualbell = false
vim.opt.wildignore:append { '*/node_modules/*', '*/bin/*', '*/obj/*' }
vim.opt.wildmenu = true -- show options as list when switching buffers etc
vim.opt.wrap = false
vim.opt.conceallevel = 0 -- never conceal
