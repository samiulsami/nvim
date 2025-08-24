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

local llama_utils = require("utils.llama_utils")

vim.g.llama_config = {
	show_info = 0,
	endpoint = llama_utils:endpoint(),
	max_line_suffix = 4096,
	auto_fim = true,
	stop_strings = { "\n" },
	keymap_accept_full = "<C-o>",
	keymap_accept_word = "<C-j>",
	ring_n_chunks = 64,
	n_prefix = 4096,
        include_recent_buffers = true,
	max_recent_buffers = 5,
	max_buffer_lines = 2000,
}

vim.g.llama_config.endpoint = "http://localhost:11397/infill"

local llama = require("utils.llama")
llama.init()
