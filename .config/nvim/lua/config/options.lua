-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- [[ Setting options ]]
-- See `:help vim.opt`
--  For more options, you can see `:help option-list`
vim.opt.number = true
vim.opt.relativenumber = true

-- Enable mouse, can be useful for resizing splits
vim.opt.mouse = "a"

vim.g.netrw_liststyle = 3 -- Tree style view in netrw

-- Sync clipboard between OS and Neovim.
--  Schedule the setting after `UiEnter` because it can increase startup-time.
--  See `:help 'clipboard'`
vim.schedule(function()
	vim.opt.clipboard = "unnamedplus"
end)

vim.opt.breakindent = true
vim.opt.autoindent = true
vim.opt.wrap = true
vim.opt.signcolumn = "yes"
vim.opt.cursorline = true

vim.opt.autoread = true
vim.opt.backspace = "indent,eol,start" -- allow unrestricted backspacing in insert mode
vim.opt.backup = false -- don't make backups before writing
vim.o.completeopt = "menu,menuone,noinsert,fuzzy,popup"
vim.opt.emoji = false -- don't assume all emoji are double width
vim.opt.foldlevelstart = 99 -- start unfolded
vim.opt.foldmethod = "indent"
vim.opt.foldcolumn = "1"
vim.opt.hidden = true

vim.opt.cindent = false
vim.opt.hlsearch = true
vim.opt.ignorecase = true
vim.opt.inccommand = "split" -- highlight and substitute while you type
vim.opt.incsearch = true
vim.opt.showmatch = true -- highlight matching [()}]

vim.opt.path:append({ "**" }) -- recursive find/search with :find, :sfind, :tabfind
vim.opt.scrolloff = 8 -- keep this number of lines visible above/below the cursor when scrolling
vim.opt.sessionoptions = "buffers,tabpages,winsize"

vim.opt.tabstop = 2 -- Number of visual spaces per TAB
vim.opt.expandtab = true -- always use spaces instead of tabs
vim.opt.shiftwidth = 2 -- Number of spaces for each >> or << indent shift
vim.opt.sidescrolloff = 8
vim.opt.smartcase = true
vim.opt.smarttab = true

-- Splitting windows below/right by default
vim.opt.splitbelow = true
vim.opt.splitright = true

vim.opt.swapfile = false
vim.opt.termguicolors = true -- use guifg/guibg instead of ctermfg/ctermbg in terminal
-- Smaller updatetime for CurshorHold & CursorHoldI
vim.opt.updatetime = 250
vim.opt.errorbells = false
vim.opt.belloff = "all" -- never ring the bell for any reason
vim.opt.visualbell = false

vim.opt.wildignore:append({ "*/node_modules/*", "*/bin/*", "*/obj/*" })
vim.opt.wildmenu = true -- show options as list when switching buffers etc
vim.opt.conceallevel = 0 -- never conceal

-- vim.opt.winbar = "%f"
vim.o.winborder = "rounded"
vim.opt.spell = false

-- Sets how neovim will display certain whitespace characters in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
vim.opt.list = true
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

vim.opt.smoothscroll = true
