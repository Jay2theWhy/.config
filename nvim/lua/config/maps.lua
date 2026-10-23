vim.g.mapleader = " "

local function map(mode, lhs, rhs)
	vim.keymap.set(mode, lhs, rhs, { silent = true })
end

-- Save
map("n", "<leader>w", "<CMD>update<CR>")

-- Quit
map("n", "<leader>q", "<CMD>q<CR>")

-- Exit insert mode
map("i", "jk", "<ESC>")

-- File explorer (netrw)
map("n", "<leader>e", "<CMD>Lexplore<CR>")
map("n", "<leader>r", "<CMD>Explore<CR>")

-- New Windows
map("n", "<leader>o", "<CMD>vsplit<CR>")
map("n", "<leader>p", "<CMD>split<CR>")

-- Window Navigation
map("n", "<C-h>", "<C-w>h")
map("n", "<C-l>", "<C-w>l")
map("n", "<C-k>", "<C-w>k")
map("n", "<C-j>", "<C-w>j")

-- netrw binds <C-l> to refresh in its buffers, which blocks moving right
vim.api.nvim_create_autocmd("FileType", {
	pattern = "netrw",
	callback = function(args)
		vim.keymap.set("n", "<C-l>", "<C-w>l", { buffer = args.buf, silent = true })
		vim.keymap.set("n", "<leader>R", "<Plug>NetrwRefresh", { buffer = args.buf, desc = "Refresh netrw" })
	end,
})

-- Resize Windows
map("n", "<C-Left>", "<C-w><")
map("n", "<C-Right>", "<C-w>>")
map("n", "<C-Up>", "<C-w>+")
map("n", "<C-Down>", "<C-w>-")
