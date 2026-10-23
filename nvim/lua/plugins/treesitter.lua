vim.pack.add({
    "https://github.com/nvim-treesitter/nvim-treesitter",
    "https://github.com/windwp/nvim-ts-autotag",
})

-- Parser builds require tree-sitter-cli (brew install tree-sitter-cli)
-- No-op for parsers that are already installed
require("nvim-treesitter").install({
    "json",
    "javascript",
    "typescript",
    "tsx",
    "yaml",
    "html",
    "css",
    "markdown",
    "markdown_inline",
    "bash",
    "lua",
    "vim",
    "dockerfile",
    "gitignore",
    "c",
    "rust",
})

-- Highlighting and indentation are opt-in per buffer on the main branch
vim.api.nvim_create_autocmd("FileType", {
    callback = function(args)
        if pcall(vim.treesitter.start, args.buf) then
            vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end
    end,
})

require("nvim-ts-autotag").setup()

-- Incremental selection, using the built-in an/in treesitter text objects
vim.keymap.set("n", "<C-space>", "van", { remap = true, desc = "Start node selection" })
vim.keymap.set("x", "<C-space>", "an", { remap = true, desc = "Expand node selection" })
vim.keymap.set("x", "<bs>", "in", { remap = true, desc = "Shrink node selection" })
