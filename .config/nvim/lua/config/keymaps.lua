local opts = { noremap = true, silent = true }

-- vim.keymap.set('n', '<leader>r', ':source ' .. vim.fn.stdpath('config') .. '/init.lua<CR>')

vim.keymap.set('x', 'p', '"_dP', opts)

vim.keymap.set('n', '<C-u>', '<C-u>zz', { desc = 'Center window after jump up' })
vim.keymap.set('n', '<C-d>', '<C-d>zz', { desc = 'Center window after jump down' })

-- Cancel default behaviour of d, D, c, C to put the text they delete in
-- the default register.
vim.keymap.set({ 'n', 'v' }, 'd', '"_d', opts)
vim.keymap.set({ 'n', 'v' }, 'D', '"_D', opts)
vim.keymap.set({ 'n', 'v' }, 'c', '"_c', opts)
vim.keymap.set({ 'n', 'v' }, 'C', '"_C', opts)

-- Using behaviour of barbar.nvim for tab buffer navigation
-- vim.keymap.set('n', '<Tab>', ':bnext<CR>')
-- vim.keymap.set('n', '<S-Tab>', ':bprevious<CR>')
-- Auto format document
vim.keymap.set('n', '<Leader>f', function() vim.lsp.buf.format() end, { desc = 'Format document' })

-- Jump through quickfix list
vim.keymap.set('n', '<M-j>', '<cmd>cnext<CR>', { desc = 'Next quickfix item' })
vim.keymap.set('n', '<M-k>', '<cmd>cnext<CR>', { desc = 'Previous quickfix item' })

-- make < > shifts keep selection
vim.keymap.set('v', '<', '<gv', opts)
vim.keymap.set('v', '>', '>gv', opts)

-- Esc to got to normal mode in terminal
vim.keymap.set('t', '<Esc>', [[<C-\><C-n>]], opts)
-- Navigating out of the terminal with the familiar keymaps
vim.keymap.set('t', '<C-k>', [[<C-\><C-n><C-w>k]], opts)
vim.keymap.set('t', '<C-h>', [[<C-\><C-n><C-w>h]], opts)

-- Split navigation using Ctrl+{hjkl}
-- See `:helm wincmd` for a list of all window commands
vim.keymap.set('n', '<C-J>', '<C-W><C-J>', { desc = 'Move focus to the window below' })
vim.keymap.set('n', '<C-K>', '<C-W><C-K>', { desc = 'Move focus to the window above' })
vim.keymap.set('n', '<C-L>', '<C-W><C-L>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-H>', '<C-W><C-H>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-Right>', ':vertical resize -3<CR>', { desc = 'Decrease vertical split size' })
vim.keymap.set('n', '<C-Left>', ':vertical resize +3<CR>', { desc = 'Increase vertical split size' })

-- Section: Moving around
-- Move cursor by display lines when wrapping
vim.keymap.set('n', 'k', 'gk', opts)
vim.keymap.set('n', 'j', 'gj', opts)
vim.keymap.set('n', '0', 'g0', opts)
vim.keymap.set('n', '$', 'g$', opts)

-- Mappings to move lines with alt+{j,k} in normal, insert, visual modes
-- Symbols are the real character generated on macOS when pressing Alt+key
vim.keymap.set('n', '∆ :m', '.+1<CR>==', opts)
vim.keymap.set('n', '<M-j> :m', '.+1<CR>==', opts)
vim.keymap.set('n', '˚ :m', '.-2<CR>==', opts)
vim.keymap.set('n', '<M-k> :m', '.-2<CR>==', opts)

vim.keymap.set('i', '∆', '<Esc>:m .+1<CR>==gi', opts)
vim.keymap.set('i', '˚', '<Esc>:m .-2<CR>==gi', opts)
vim.keymap.set('v', '∆', ":m '>+1<CR>gv=gv", opts)
vim.keymap.set('v', '<M-j>', ":m '>+1<CR>gv=gv", opts)
vim.keymap.set('v', '˚', ":m, '<-2<CR>gv=gv", opts)
vim.keymap.set('v', '<M-k>', ":m '<-2<CR>gv=gv", opts)

-- Clear search highlights with esc
vim.keymap.set('n', '<Esc>', ':silent! nohls<CR>', opts)

-- <leader>q to delete buffer without closing window
vim.keymap.set('n', '<leader>q', ':bp<CR>:bd#<CR>', opts)

vim.keymap.set('n', '<space><space>x', '<cmd> source %<CR>')
vim.keymap.set('n', '<space>x', ':.lua<CR>')
vim.keymap.set('v', '<space>x', ':lua<CR>')

-- vim.keymap.set('n', '<C-b>', ':25Lex<CR>') -- Toggle netrw tree view

--vim.keymap.set('i', '<CR>', function()
--  return vim.fn.pumvisible() == 1 and '<C-y>' or '<CR>'
--end, { expr = true })

-- vim.keymap.set('i', '<C-Space>', '<C-x><C-o>', { expr = true })
-- vim.keymap.set('i', '<C-@>', '<C-x><C-o>', { expr = true })

-- vim.keymap.set('i', '<Tab>', function()
--   return vim.fn.pumvisible() == 1 and '<C-n>' or '<Tab>'
-- end, { expr = true })
-- vim.keymap.set('i', '<S-Tab>', function()
--   return vim.fn.pumvisible() == 1 and '<C-p>' or '<S-Tab>'
-- end, { expr = true })
