vim.api.nvim_set_option('statusline', ''
  .. '%{luaeval("require\'lsp-status\'.status()")}'                            -- LSP 
  .. '%{FugitiveStatusline()}'                   -- Git branch
  .. ' %f'                                       -- File path
  .. '%='                                        -- Split point for left and right groups.
  .. '%#CursorColumn#'                           -- Change background
  .. ' Ln %l, Col %c'                                    -- Line:column
  .. ' %{&fileencoding?&fileencoding:&encoding}' -- File encoding
  .. ' [%{&filetype}]'                            -- File type
)
