-- Leader must be set before any plugin mappings are created
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

require("config.settings")
require("config.maps")
require("config.pack")

vim.g.netrw_bufsettings = "noma nomod nu rnu nobl nowrap ro"
