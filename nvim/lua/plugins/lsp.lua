vim.pack.add({
	"https://github.com/mason-org/mason.nvim",
	-- Only provides server configs (lsp/*.lua) for vim.lsp.enable()
	"https://github.com/neovim/nvim-lspconfig",
})

-- Also puts mason/bin on PATH so conform and the servers are found
require("mason").setup()

-- Mason package names, installed automatically if missing
local ensure_installed = {
	-- language servers
	"css-lsp",
	"eslint-lsp",
	"html-lsp",
	"json-lsp",
	"pyright",
	"tailwindcss-language-server",
	"typescript-language-server",
	-- formatters (used by conform)
	"prettier",
	"stylua",
	"isort",
	"black",
}

local registry = require("mason-registry")
registry.refresh(function()
	for _, name in ipairs(ensure_installed) do
		local pkg = registry.get_package(name)
		if not pkg:is_installed() and not pkg:is_installing() then
			pkg:install()
		end
	end
end)

-- nvim-lspconfig server names
vim.lsp.enable({
	"cssls",
	"eslint",
	"html",
	"jsonls",
	"pyright",
	"tailwindcss",
	"ts_ls",
})
