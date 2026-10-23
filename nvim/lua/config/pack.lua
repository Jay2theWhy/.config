-- Plugins are managed by the built-in vim.pack (:h vim.pack)
--   Update:  :lua vim.pack.update()
--   Remove:  delete the spec below, then :lua vim.pack.del({ "name" })
-- Versions are pinned in nvim-pack-lock.json, which should be committed.

-- Build hooks must be registered before vim.pack.add() so they fire on install
vim.api.nvim_create_autocmd("PackChanged", {
	callback = function(ev)
		local name, kind = ev.data.spec.name, ev.data.kind
		if name == "nvim-treesitter" and (kind == "install" or kind == "update") then
			if not ev.data.active then
				vim.cmd.packadd("nvim-treesitter")
			end
			vim.cmd("TSUpdate")
		end
	end,
})

-- Colorscheme first so everything else loads with the right highlights
local plugins = {
	"colorscheme",
	"treesitter",
	"lsp",
	"autopairs",
	"colorizer",
	"formatter",
	"gitsigns",
	"harpoon",
	"telescope",
}

for _, plugin in ipairs(plugins) do
	require("plugins." .. plugin)
end
