local function map(mode, lhs, rhs, desc)
	vim.keymap.set(mode, lhs, rhs, { silent = true, desc = desc })
end

-- Save
map("n", "<leader>w", "<CMD>update<CR>", "Save file")

-- Quit
map("n", "<leader>q", "<CMD>q<CR>", "Quit window")

-- Exit insert mode
map("i", "jk", "<ESC>", "Exit insert mode")

-- File explorer (netrw)
map("n", "<leader>e", "<CMD>Lexplore<CR>", "Toggle netrw sidebar")
map("n", "<leader>r", "<CMD>Explore<CR>", "Open netrw in current window")

-- New Windows
map("n", "<leader>|", "<CMD>vsplit<CR>", "Split window right")
map("n", "<leader>-", "<CMD>split<CR>", "Split window below")

-- Window Navigation
map("n", "<C-h>", "<C-w>h", "Go to left window")
map("n", "<C-l>", "<C-w>l", "Go to right window")
map("n", "<C-k>", "<C-w>k", "Go to upper window")
map("n", "<C-j>", "<C-w>j", "Go to lower window")

-- netrw binds <C-l> to refresh in its buffers, which blocks moving right.
-- Refresh moves to <C-r>, replacing netrw's server-edit (needs Vim's clientserver)
vim.api.nvim_create_autocmd("FileType", {
	pattern = "netrw",
	callback = function(args)
		local opts = { buffer = args.buf, silent = true }
		vim.keymap.set("n", "<C-l>", "<C-w>l", vim.tbl_extend("force", opts, { desc = "Go to right window" }))
		vim.keymap.set("n", "<C-r>", "<Plug>NetrwRefresh", vim.tbl_extend("force", opts, { desc = "Refresh netrw" }))
	end,
})

-- Resize Windows (<C-arrows> are taken by macOS Mission Control / Spaces)
map("n", "<M-Left>", "<CMD>vertical resize -2<CR>", "Decrease window width")
map("n", "<M-Right>", "<CMD>vertical resize +2<CR>", "Increase window width")
map("n", "<M-Up>", "<CMD>resize +2<CR>", "Increase window height")
map("n", "<M-Down>", "<CMD>resize -2<CR>", "Decrease window height")
