vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.keymap.set("n", "Q", "<Nop>", { noremap = true })

require("utils.notifications").setup()
require("config.lspconfig")
require("config.config")
require("config.formatting")
require("config.keybinds")
require("config.profiling")
require("config.lazy")
require("utils.unique_lines")
require("utils.git_utils")
