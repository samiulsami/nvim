vim.g.mapleader = " "
vim.g.undotree_RelativeTimestamp = false
vim.g.maplocalleader = " "

require("config.lspconfig")
require("config.config")
require("config.formatting")
require("config.keybinds")
require("config.profiling")
require("config.lazy")
require("utils.unique_lines")

require("utils.fFtT_highlights"):setup({
	case_sensitivity = "smart",
	show_unique_word_chars = "always",
	show_all_unique_chars = "on_key_press",
})
