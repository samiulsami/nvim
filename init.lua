vim.g.mapleader = " "
vim.g.undotree_RelativeTimestamp = false
vim.g.maplocalleader = " "

require("config.config")
require("config.formatting")
require("config.keybinds")
require("config.profiling")
require("config.lazy")

require("custom-scripts.copy_path")
