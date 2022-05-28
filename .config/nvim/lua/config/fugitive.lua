local M = {}

function M.setup()
  vim.keymap.set('n', '<C-g>', function()
    if vim.fn.buflisted(vim.fn.bufname('.git/index')) == 1 then
      vim.cmd [[ bd .git/index ]]
    else
      vim.cmd [[ 
        Git 
        " 15wincmd_
      ]]
    end
  end, {})
end

return M
