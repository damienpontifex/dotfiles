vim.keymap.set(
	"n",
	"<leader>r",
	":source " .. vim.fn.stdpath("config") .. "/init.lua<CR>",
	{ desc = "Reload neovim config" }
)

vim.keymap.set("x", "p", '"_dP')

-- Center screen when jumping
-- vim.keymap.set('n', '<C-u>', '<C-u>zz', { desc = 'Center window after jump up' })
-- vim.keymap.set('n', '<C-d>', '<C-d>zz', { desc = 'Center window after jump down' })
-- vim.keymap.set('n', '}', '}zz', { desc = 'Center window after jump to next paragraph' })
-- vim.keymap.set('n', '{', '{zz', { desc = 'Center window after jump to previous paragraph' })
-- vim.keymap.set('n', 'n', 'nzzzv', { desc = 'Center window after search next' })
-- vim.keymap.set('n', 'N', 'Nzzzv', { desc = 'Center window after search previous' })

-- Cancel default behaviour of d, D, c, C to put the text they delete in
-- the default register.
vim.keymap.set({ "n", "v" }, "d", '"_d')
vim.keymap.set({ "n", "v" }, "D", '"_D')
vim.keymap.set({ "n", "v" }, "c", '"_c')
vim.keymap.set({ "n", "v" }, "C", '"_C')

-- Using behaviour of barbar.nvim for tab buffer navigation
-- vim.keymap.set('n', '<Tab>', ':bnext<CR>')
-- vim.keymap.set('n', '<S-Tab>', ':bprevious<CR>')
-- Auto format document
vim.keymap.set("n", "<Leader>f", function()
	vim.lsp.buf.format()
end, { desc = "Format document" })

-- Jump through quickfix list
-- TODO: revisit this as I use this for navigating tmux windows
-- vim.keymap.set("n", "<M-j>", "<cmd>cnext<CR>", { desc = "Next quickfix item" })
-- vim.keymap.set("n", "<M-k>", "<cmd>cnext<CR>", { desc = "Previous quickfix item" })

vim.keymap.set("v", "<", "<gv", { desc = "Shift left and keep selection" })
vim.keymap.set("v", ">", ">gv", { desc = "Shift right and keep selection" })

vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]], { desc = "Use escape to go to normal mode in terminal" })
vim.keymap.set("t", "<C-k>", [[<C-\><C-n><C-w>k]], { desc = "Move focus to the window above from terminal mode" })
vim.keymap.set("t", "<C-h>", [[<C-\><C-n><C-w>h]], { desc = "Move focus to the left window from terminal mode" })

vim.keymap.set("n", "<C-J>", "<C-W><C-J>", { desc = "Move focus to the window below" })
vim.keymap.set("n", "<C-K>", "<C-W><C-K>", { desc = "Move focus to the window above" })
vim.keymap.set("n", "<C-L>", "<C-W><C-L>", { desc = "Move focus to the right window" })
vim.keymap.set("n", "<C-H>", "<C-W><C-H>", { desc = "Move focus to the left window" })
vim.keymap.set("n", "<C-Right>", ":vertical resize -5<CR>", { desc = "Decrease vertical split size" })
vim.keymap.set("n", "<C-Left>", ":vertical resize +5<CR>", { desc = "Increase vertical split size" })

-- Folding
-- Loop over z0, z1, z2…z9 to set foldlevel
for i = 0, 9 do
	vim.keymap.set("n", "z" .. i, function()
		vim.opt.foldlevel = i
	end, { desc = "Set foldlevel to " .. i })
end

-- Section: Moving around
-- When nowrap, jump to the actual start and end of the line
-- vim.keymap.set("n", "0", "call cursor(line('.'), 1)<CR>")
-- vim.keymap.set("n", "$", "call cursor(line('.'), col('$'))<CR>")

-- Mappings to move lines with alt+{j,k} in normal, insert, visual modes
-- Symbols are the real character generated on macOS when pressing Alt+key
vim.keymap.set("n", "∆", ":move .+1<CR>==", { desc = "Move line down" })
vim.keymap.set("n", "<M-j>", ":move .+1<CR>==", { desc = "Move line down" })
vim.keymap.set("n", "˚", ":move .-2<CR>==", { desc = "Move line up" })
vim.keymap.set("n", "<M-k>", ":move .-2<CR>==", { desc = "Move line up" })

vim.keymap.set("i", "∆", "<Esc>:move .+1<CR>==gi", { desc = "Move line down" })
vim.keymap.set("i", "<M-j>", "<Esc>:move .+1<CR>==gi", { desc = "Move line down" })
vim.keymap.set("i", "˚", "<Esc>:move .-2<CR>==gi", { desc = "Move line up" })
vim.keymap.set("i", "<M-k>", "<Esc>:move .-2<CR>==gi", { desc = "Move line up" })

vim.keymap.set("v", "∆", ":move '>+1<CR>gv=gv", { desc = "Move line down" })
vim.keymap.set("v", "<M-j>", ":move '>+1<CR>gv=gv", { desc = "Move line down" })
vim.keymap.set("v", "˚", ":move '<-2<CR>gv=gv", { desc = "Move line up" })
vim.keymap.set("v", "<M-k>", ":move '<-2<CR>gv=gv", { desc = "Move line up" })

-- Clear search highlights with esc
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- <leader>q to delete buffer without closing window
-- vim.keymap.set("n", "<leader>q", ":bp<CR>:bd#<CR>")
vim.keymap.set("n", "<leader>q", function()
	local listed_buffers = vim.tbl_filter(function(buf)
		return vim.fn.buflisted(buf) == 1
	end, vim.api.nvim_list_bufs())
	if #listed_buffers > 1 then
		vim.cmd("bp")
		vim.cmd("bd#")
	else
		vim.cmd("bd")
		vim.cmd("enew")
	end
end, { desc = "Smart buffer close & cycle" })

vim.keymap.set("n", "<space><space>x", "<cmd> source %<CR>", { desc = "Run current lua file" })
vim.keymap.set("n", "<leader>x", ":.lua<CR>", { desc = "Run current lua line" })
vim.keymap.set("v", "<leader>x", ":lua<CR>", { desc = "Run selected lua code" })
