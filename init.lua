vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.schedule(vim.cmd.clearjumps)

if os.getenv("NVIM_NO_TRANSPARENCY") then
	vim.schedule(function()
		local buffer_bg_color = "#191a1c"
		vim.api.nvim_set_hl(0, "Normal", { bg = buffer_bg_color })
		vim.api.nvim_set_hl(0, "NormalNC", { bg = buffer_bg_color })
		vim.api.nvim_set_hl(0, "EndOfBuffer", { bg = buffer_bg_color })
	end)
end

require("utils.notifications").setup()
require("config.config")
require("config.lspconfig")
require("config.appearance")
require("config.keybinds")
require("config.lazy")
require("utils.tmux_navigation").setup_keymaps()
require("utils.unique_lines")
require("utils.git_utils")
