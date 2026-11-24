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
	"lua-language-server",
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
		-- get_package throws on unknown names; warn instead of breaking startup
		local ok, pkg = pcall(registry.get_package, name)
		if not ok then
			vim.schedule(function()
				vim.notify(("mason: unknown package %q"):format(name), vim.log.levels.WARN)
			end)
		elseif not pkg:is_installed() and not pkg:is_installing() then
			-- Failures are otherwise only visible in :MasonLog
			pkg:install({}, function(success, err)
				if not success then
					vim.schedule(function()
						vim.notify(("mason: failed to install %s\n%s"):format(name, tostring(err)), vim.log.levels.WARN)
					end)
				end
			end)
		end
	end
end)

-- Teach lua_ls about Neovim's runtime so `vim.*` is known while editing this config
vim.lsp.config("lua_ls", {
	settings = {
		Lua = {
			runtime = { version = "LuaJIT" },
			workspace = {
				checkThirdParty = false,
				library = { vim.env.VIMRUNTIME },
			},
		},
	},
})

-- nvim-lspconfig server names
vim.lsp.enable({
	"cssls",
	"eslint",
	"html",
	"jsonls",
	"lua_ls",
	"pyright",
	"tailwindcss",
	"ts_ls",
})

-- Show diagnostic messages inline (off by default since 0.11)
vim.diagnostic.config({ virtual_text = true })

-- Built-in LSP completion, triggered automatically as you type
vim.o.completeopt = "menuone,noselect,popup,fuzzy"
vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(ev)
		-- Same as <C-]> (LSP definition via tagfunc), so <C-t> jumps back
		vim.keymap.set("n", "gd", "<C-]>", { buffer = ev.buf, desc = "Go to definition" })

		local client = vim.lsp.get_client_by_id(ev.data.client_id)
		if client and client:supports_method("textDocument/completion") then
			vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
		end
	end,
})
