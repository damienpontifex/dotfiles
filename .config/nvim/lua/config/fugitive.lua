local M = {}

function M.setup()

  print('fugitive setup')
  local opts = { noremap = true, silent = true }

  -- Toggle git pane
  vim.keymap.set('n', '<C-g>', function()
    if vim.fn.buflisted(vim.fn.bufname('.git//')) == 1 then
      vim.cmd [[ bd .git// ]]
    else
      vim.cmd [[ 
        Git 
        " 15wincmd_
      ]]
    end
  end, opts)

end

return M
