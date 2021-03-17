local set = vim.o

vim.bo.swapfile = false
vim.wo.wrap = false
-- vim.wo.colorcolumn = +1

set.termguicolors = true
vim.wo.number = true
vim.wo.relativenumber = true
set.mouse = 'a' -- Enable mouse
set.clipboard = 'unnamed' -- Use OS clipboard
set.hidden = true -- Allow unsaved changes in buffers

set.scrolloff = 8
set.sidescrolloff = 8
vim.wo.colorcolumn = '80'

vim.wo.cursorline = true -- highlight current line
vim.bo.tabstop = 2 -- Number of visual spaces per TAB
vim.bo.shiftwidth = 2 -- Number of spaces for each >> or << indent shift
-- Workaround as vim.bo.shiftwidth doesn't seem to be working in my buffers
vim.api.nvim_set_option('shiftwidth', 2)
vim.bo.expandtab = true -- tabs are space
vim.bo.cindent = true
set.showmatch = true -- highlight matching [()}]
set.smarttab = true

vim.wo.foldmethod = 'syntax'
set.foldlevelstart = 99

-- Incremental search
set.incsearch = true
set.ignorecase = true
set.smartcase = true
-- Recursive find/search
-- set.path += '**'
set.wildmenu = true -- Visual autocomplete for command menu

set.inccommand = 'nosplit' -- highlight and substitute while you type

-- More natural split opening
set.splitright = true
set.splitbelow = true

set.hlsearch = true -- higlight matches

set.sessionoptions = 'buffers,tabpages,winsize'
set.backspace = 'indent,eol,start'

-- Disable beeping and flashing
set.errorbells = false
set.visualbell = false

set.updatetime = 300 -- smaller updatetime for CurshorHold & CursorHoldI
set.autoread = true -- atuo reload file if changed on disk
