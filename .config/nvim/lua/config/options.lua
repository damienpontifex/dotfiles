--  For more options, you can see `:help option-list`

-- ============================================================
-- UI
-- ============================================================
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true
vim.opt.signcolumn = "yes"
vim.opt.colorcolumn = "120"
vim.opt.termguicolors = true
vim.opt.winborder = "rounded"
vim.opt.smoothscroll = true
vim.opt.list = true
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

-- ============================================================
-- Search
-- ============================================================
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.inccommand = "split" -- live preview of substitutions in a split
vim.opt.showmatch = true -- briefly jump to matching bracket

-- ============================================================
-- Indentation
-- ============================================================
vim.opt.breakindent = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true

-- ============================================================
-- Folding
-- ============================================================
vim.opt.foldlevelstart = 99 -- open all folds when opening a file
vim.opt.foldmethod = "indent"
vim.opt.foldcolumn = "1"
vim.opt.fillchars = "fold: ,eob: ,foldopen:,foldsep: ,foldclose:,foldinner: "

-- ============================================================
-- Windows & Scrolling
-- ============================================================
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 8

-- ============================================================
-- Files & Buffers
-- ============================================================
vim.opt.autowrite = true
vim.opt.autowriteall = true
vim.opt.swapfile = false
vim.opt.updatetime = 250 -- faster CursorHold events (affects diagnostics, git signs)
vim.opt.sessionoptions = "buffers,tabpages,winsize"
vim.opt.undodir = vim.fn.stdpath('data') .. '/undodir'
vim.opt.undofile = true

-- ============================================================
-- Completion & Navigation
-- ============================================================
vim.opt.completeopt:append({"menuone", "noselect",  "noinsert", "fuzzy"})
vim.opt.path:append({ "**" }) -- recursive :find / :sfind / :tabfind
vim.opt.wildignore:append({ "*/node_modules/*", "*/bin/*", "*/obj/*" })

-- ============================================================
-- Misc
-- ============================================================
vim.opt.mouse = "a"
vim.opt.emoji = false -- don't assume all emoji are double-width

-- Sync clipboard between OS and Neovim.
-- Scheduled after UiEnter to avoid increasing startup time.
-- See `:help 'clipboard'`
vim.schedule(function()
	vim.opt.clipboard = "unnamedplus"
end)
