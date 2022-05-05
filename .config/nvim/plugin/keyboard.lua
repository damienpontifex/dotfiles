local opts = { noremap = true, silent = true }

vim.keymap.set('x', 'p', '"_dP', opts)

-- Cancel default behaviour of d, D, c, C to put the text they delete in
-- the default register.
vim.keymap.set({ 'n', 'v' }, 'd', '"_d', opts)
vim.keymap.set({ 'n', 'v' }, 'D', '"_D', opts)
vim.keymap.set({ 'n', 'v' }, 'c', '"_c', opts)
vim.keymap.set({ 'n', 'v' }, 'C', '"_C', opts)

-- Auto format document
vim.keymap.set('n', '<Tab>', ':bnext<CR>')
vim.keymap.set('n', '<S-Tab>', ':bprevious<CR>')
-- vim.keymap.set('n', 'F', "gg=G''<CR>")

-- make < > shifts keep selection
vim.keymap.set('v', '<', '<gv', opts)
vim.keymap.set('v', '>', '>gv', opts)

-- Esc to got to normal mode in terminal
vim.keymap.set('t', '<Esc>', [[<C-\><C-n>]], opts)

-- -- Split navigation using Ctrl+{hjkl}
-- vim.keymap.set('n', '<C-J>', '<C-W><C-J>', opts)
-- vim.keymap.set('n', '<C-K>', '<C-W><C-K>', opts)
-- vim.keymap.set('n', '<C-L>', '<C-W><C-L>', opts)
-- vim.keymap.set('n', '<C-H>', '<C-W><C-H>', opts)

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
vim.keymap.set('v', '∆' , ":m '>+1<CR>gv=gv", opts)
vim.keymap.set('v', '<M-j>', ":m '>+1<CR>gv=gv", opts)
vim.keymap.set('v', '˚', ":m, '<-2<CR>gv=gv", opts)
vim.keymap.set('v', '<M-k>', ":m '<-2<CR>gv=gv", opts)

-- Clear search highlights with double esc
vim.keymap.set('n', '<esc><esc>', ':silent! nohls<CR>', opts)

-- \q to delete buffer without closing window
vim.keymap.set('n', '<leader>q', ':bp<CR>:bd#<CR>', opts)

--vim.keymap.set('i', '<CR>', function()
--  return vim.fn.pumvisible() == 1 and '<C-y>' or '<CR>'
--end, { expr = true })

-- vim.keymap.set('i', '<C-Space>', '<C-x><C-o>', { expr = true })
-- vim.keymap.set('i', '<C-@>', '<C-x><C-o>', { expr = true })
vim.keymap.set('i', '<Tab>', function()
  return vim.fn.pumvisible() == 1 and '<C-n>' or '<Tab>'
end, { expr = true })
vim.keymap.set('i', '<S-Tab>', function()
  return vim.fn.pumvisible() == 1 and '<C-p>' or '<S-Tab>'
end, { expr = true })

