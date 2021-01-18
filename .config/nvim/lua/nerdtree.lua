vim.g.NERDTreeShowHidden = 1
vim.g.NERDTreeRespectWildIgnore = 1
vim.g.NERDTreeIgnore = {'.git/', '__pycache__', '.ipynb_checkpoints', 'bin/', 'obj'}

vim.api.nvim_set_keymap('n', '<C-b>', ':NERDTreeToggle<CR>', { noremap = true, silent = true })
