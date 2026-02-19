vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.schedule(vim.cmd.clearjumps)

require("utils.notifications").setup()
require("config.config")
require("config.lspconfig")
require("config.appearance")
require("config.keybinds")
require("config.lazy")
require("utils.tmux_navigation").setup_keymaps()
require("utils.unique_lines")
require("utils.git_utils")

local arg = vim.fn.argv(0)
if type(arg) == "string" and arg == "." then
	vim.schedule(function()
		vim.cmd("AutoSession restore")
	end)
end
