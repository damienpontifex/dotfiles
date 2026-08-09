vim.keymap.set("n", "<leader>re", function()
	require("auto-session").save_session()
	vim.cmd("restart AutoSession restore")
end, { desc = "Save session, restart neovim, and reload session" })

-- Automatically switches forward and backward search to "Very Magic" mode i.e. +, ?, {, (, and | are not treated as literals
vim.keymap.set({ "n", "v" }, "/", "/\\v")
vim.keymap.set({ "n", "v" }, "?", "?\\v")

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
local function toggle_terminal()
	local term_buf = vim.iter(vim.api.nvim_list_bufs()):find(function(buf)
		return vim.bo[buf].buftype == "terminal"
	end)

	local one_third_height = math.floor(vim.o.lines / 3)
	if term_buf then
		local term_win = vim.iter(vim.api.nvim_list_wins()):find(function(win)
			return vim.api.nvim_win_get_buf(win) == term_buf
		end)

		if term_win then
			-- If already visible on screen, just jump your cursor to that window
			vim.api.nvim_set_current_win(term_win)
		else
			-- If the buffer exists but is hidden, open a new split for it
			vim.cmd("horizontal split")
			vim.api.nvim_win_set_buf(0, term_buf)
			vim.api.nvim_win_set_height(0, one_third_height)
		end
	else
		vim.cmd("horizontal terminal")
		vim.api.nvim_win_set_height(0, one_third_height)
	end
	vim.cmd("startinsert")
end
vim.keymap.set("n", "<M-`>", toggle_terminal, { desc = "Open terminal in horizontal split" })
vim.keymap.set("t", "<M-`>", [[<C-\><C-n>:hide<CR>]], { desc = "Hide terminal when inside the terminal" })

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
vim.keymap.set("n", "<leader>w", function()
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
vim.keymap.set("n", "<leader>qq", "<cmd>%bd<CR>", { silent = true, desc = "Delete all buffers" })
vim.keymap.set("n", "<leader>qo", "<cmd>%bd|e#<CR>", { silent = true, desc = "Delete all buffers except this one" })

vim.keymap.set("n", "<space><space>x", "<cmd> source %<CR>", { desc = "Run current lua file" })
vim.keymap.set("n", "<leader>x", ":.lua<CR>", { desc = "Run current lua line" })
vim.keymap.set("v", "<leader>x", ":lua<CR>", { desc = "Run selected lua code" })
