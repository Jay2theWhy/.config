vim.pack.add({
	"https://github.com/nvim-lua/plenary.nvim",
	{ src = "https://github.com/ThePrimeagen/harpoon", version = "harpoon2" },
})

local harpoon = require("harpoon")
---@diagnostic disable-next-line: missing-parameter
harpoon:setup()
local function map(lhs, rhs, opts)
	vim.keymap.set("n", lhs, rhs, opts or {})
end
map("<leader>a", function()
	harpoon:list():add()
end, { desc = "Harpoon add file" })
map("<leader>h", function()
	harpoon.ui:toggle_quick_menu(harpoon:list())
end, { desc = "Harpoon menu" })
map("<leader>1", function()
	harpoon:list():select(1)
end, { desc = "Harpoon file 1" })
map("<leader>2", function()
	harpoon:list():select(2)
end, { desc = "Harpoon file 2" })
map("<leader>3", function()
	harpoon:list():select(3)
end, { desc = "Harpoon file 3" })
map("<leader>4", function()
	harpoon:list():select(4)
end, { desc = "Harpoon file 4" })
