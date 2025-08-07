local function augroup(name)
  return vim.api.nvim_create_augroup("pontifex_" .. name, { clear = true })
end

-- resize splits if window got resized
vim.api.nvim_create_autocmd({ "VimResized" }, {
  group = augroup("resize_splits"),
  callback = function()
    local current_tab = vim.fn.tabpagenr()
    vim.cmd("tabdo wincmd =")
    vim.cmd("tabnext " .. current_tab)
  end
})

-- Auto create dir when saving a file, in case some intermediate directory does not exist
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
  group = augroup("auto_create_dir"),
  callback = function()
    local dir = vim.fn.expand('<afile>:p:h')
    if vim.fn.isdirectory(dir) == 0 then
      vim.fn.mkdir(dir, "p")
    end
  end,
})

-- Return to last edit position when opening a file
vim.api.nvim_create_autocmd({ "BufReadPost" }, {
  group = augroup("last_edit_position"),
  callback = function(event)
    local mark = vim.api.nvim_buf_get_mark(event.buf, '"')
    local lcount = vim.api.nvim_buf_line_count(event.buf)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- Check if we need to reload the file when it changed
vim.api.nvim_create_autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
  group = augroup("checktime"),
  callback = function()
    if vim.o.buftype ~= 'nofile' then
      vim.cmd('checktime')
    end
  end
})

-- Highlight on yank
vim.api.nvim_create_autocmd({ "TextYankPost" }, {
  callback = function()
    vim.highlight.on_yank({ higroup = "Visual", timeout = 200 })
  end,
})

vim.api.nvim_create_autocmd('TermOpen', {
  group = vim.api.nvim_create_augroup('custom-term-open', { clear = true }),
  callback = function()
    -- No line numbers in terminal
    vim.opt.number = false
    vim.opt.relativenumber = false
  end
})

-- Auto close terminal buffer when process it exits
vim.api.nvim_create_autocmd('TermClose', {
  group = vim.api.nvim_create_augroup('custom-term-close', { clear = true }),
  callback = function()
    if vim.v.event.status == 0 then
      vim.api.nvim_buf_delete(0, {})
    end
  end,
})

-- Save and load session on close and open
-- local session_group = vim.api.nvim_create_augroup("pontifex_session", { clear = true })
-- vim.api.nvim_create_autocmd({ "VimLeave" }, {
--   pattern = "?*",
--   group = session_group,
--   callback = function()
--     vim.cmd([[silent! mksession! .session.vim]])
--   end,
-- })
-- vim.api.nvim_create_autocmd({ "VimEnter" }, {
--   pattern = "?*",
--   group = session_group,
--   callback = function()
--     -- If .session.vim exists in the current directory, load it
--     local session_file = vim.fn.getcwd() .. "/.session.vim"
--     if vim.fn.filereadable(session_file) == 1 then
--       vim.cmd([[silent! source .session.vim]])
--     end
--   end,
-- })
