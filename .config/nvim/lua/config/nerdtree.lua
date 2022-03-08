local M = {}

function M.setup()
  vim.g.NERDTreeShowHidden = 1
  vim.g.NERDTreeRespectWildIgnore = 1
  vim.g.NERDTreeIgnore = {'.git/', '__pycache__', '.ipynb_checkpoints', 'bin/', 'obj'}
  vim.g.NERDTreeMouseMode = 3 -- Single click to open/edit

  vim.api.nvim_set_keymap('n', '<C-b>', ':NERDTreeToggle<CR>', { noremap = true, silent = true })

  -- Open nerdtree and focus in editor if no arguments given to nvim
  -- vim.cmd("autocmd VimEnter * if !argc() | NERDTree | wincmd p | endif")
end

return M
