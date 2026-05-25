vim.g.mapleader = " "
vim.g.maplocalleader = " "

require("utils.notifications").setup()
require("config.config")
require("config.lspconfig")
require("config.appearance")
require("config.keybinds")
require("utils.tmux_navigation").setup_keymaps()
require("utils.unique_lines")
require("utils.git_utils")

local project_shada = require("utils.project_shada").setup()
local arg = vim.fn.argv(0)
if type(arg) == "string" and arg == "." then
	vim.api.nvim_create_autocmd("VimEnter", {
		once = true,
		nested = true,
		callback = function()
			local startup_buf = vim.api.nvim_get_current_buf()
			local startup_name = vim.api.nvim_buf_get_name(startup_buf)
			if startup_name == "." or vim.fn.isdirectory(startup_name) == 1 then
				vim.cmd("silent keepalt keepjumps enew")
				pcall(vim.api.nvim_buf_delete, startup_buf, { force = true })
			end

			project_shada.restore_last_buffer()
		end,
	})
else
	vim.cmd("clearjumps")
	vim.cmd("silent! wshada!")
end

local config_dir = vim.fs.dirname(vim.env.MYVIMRC)
require("config.pack"):load_plugins(vim.fs.joinpath(config_dir, "lua", "plugins", "*.lua"))
