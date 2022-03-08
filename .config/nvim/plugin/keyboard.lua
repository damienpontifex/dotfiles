local opts = { noremap = true, silent = true }
local function nnoremap(key, cmd) vim.api.nvim_set_keymap('n', key, cmd, opts) end
local function vnoremap(key, cmd) vim.api.nvim_set_keymap('v', key, cmd, opts) end
local function inoremap(key, cmd) vim.api.nvim_set_keymap('i', key, cmd, opts) end
local function xnoremap(key, cmd) vim.api.nvim_set_keymap('x', key, cmd, opts) end

xnoremap('p', '"_dP')

-- Cancel default behaviour of d, D, c, C to put the text they delete in
-- the default register.
nnoremap('d', '"_d')
vnoremap('d', '"_d')
nnoremap('D', '"_D')
vnoremap('D', '"_D')
nnoremap('c', '"_c')
vnoremap('c', '"_c')
nnoremap('C', '"_C')
vnoremap('C', '"_C')

-- Auto format document
nnoremap('<Tab>', ':bnext<CR>')
nnoremap('<S-Tab>', ':bprevious<CR>')
-- nnoremap('F', "gg=G''<CR>")

-- make < > shifts keep selection
vnoremap('<', '<gv')
vnoremap('>', '>gv')

-- Esc to got to normal mode in terminal
vim.api.nvim_set_keymap('t', '<Esc>', [[<C-\><C-n>]], opts)

-- -- Split navigation using Ctrl+{hjkl}
-- nnoremap('<C-J>', '<C-W><C-J>')
-- nnoremap('<C-K>', '<C-W><C-K>')
-- nnoremap('<C-L>', '<C-W><C-L>')
-- nnoremap('<C-H>', '<C-W><C-H>')

-- Section: Moving around
-- Move cursor by display lines when wrapping
nnoremap('k', 'gk')
nnoremap('j', 'gj')
nnoremap('0', 'g0')
nnoremap('$', 'g$')

-- Mappings to move lines with alt+{j,k} in normal, insert, visual modes
-- Symbols are the real character generated on macOS when pressing Alt+key
nnoremap('∆ :m', '.+1<CR>==')
nnoremap('<M-j> :m', '.+1<CR>==')
nnoremap('˚ :m', '.-2<CR>==')
nnoremap('<M-k> :m', '.-2<CR>==')

inoremap('∆', '<Esc>:m .+1<CR>==gi')
inoremap('˚', '<Esc>:m .-2<CR>==gi')
vnoremap('∆' , ":m '>+1<CR>gv=gv")
vnoremap('<M-j>', ":m '>+1<CR>gv=gv")
vnoremap('˚', ":m, '<-2<CR>gv=gv")
vnoremap('<M-k>', ":m '<-2<CR>gv=gv")

-- Clear search highlights with double esc
nnoremap('<esc><esc>', ':silent! nohls<CR>')

vim.cmd [[
  " Section: Popup Menu
  " When popup menu is visible - Enter key selects highlighted menu item
  inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
  " Ctrl+Space when in insert mode to launch omni completion for ins-completion
  " http://vimdoc.sourceforge.net/htmldoc/insert.html#ins-completion
  inoremap <expr> <C-Space> "\<C-x>\<C-o>"
  inoremap <expr> <C-@> "\<C-x>\<C-o>"
  inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
  inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
  autocmd! CompleteDone * if pumvisible() == 0 | pclose | endif

  " \q to delete buffer without closing window
  map <leader>q :bp<CR>:bd#<CR>
]]

