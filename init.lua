vim.g.mapleader = " "
vim.g.maplocalleader = " "

require("utils.notifications").setup()
require("config.config")
require("config.lspconfig")
require("config.appearance")
require("config.keybinds")
require("config.profiling")
require("config.lazy")
require("utils.unique_lines")
require("utils.git_utils")
