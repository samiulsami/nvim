vim.g.mapleader = " "
vim.g.maplocalleader = " "

require("utils.notifications").setup()
local project_shada = require("utils.project_shada").setup()
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
		local startup_buf = vim.api.nvim_get_current_buf()
		local startup_name = vim.api.nvim_buf_get_name(startup_buf)
		if startup_name == "." or vim.fn.isdirectory(startup_name) == 1 then
			vim.cmd("silent keepalt keepjumps enew")
			pcall(vim.api.nvim_buf_delete, startup_buf, { force = true })
		end

		project_shada.restore_last_buffer()
	end)
else
	vim.cmd("clearjumps")
	vim.cmd("silent! wshada!")
end
