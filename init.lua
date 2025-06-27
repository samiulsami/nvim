vim.g.mapleader = " "
vim.g.undotree_RelativeTimestamp = false
vim.g.maplocalleader = " "

require("utils.notifications").setup()
require("config.lspconfig")
require("config.config")
require("config.formatting")
require("config.keybinds")
require("config.profiling")
require("config.lazy")
require("utils.unique_lines")
