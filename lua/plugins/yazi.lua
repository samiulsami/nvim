return {
	"mikavilpas/yazi.nvim",
	event = "VeryLazy",
	keys = {
		{
			"<leader>p",
			mode = { "n", "v" },
			"<cmd>Yazi<cr>",
			desc = "Open yazi at the current file",
		},
	},
	---@module 'yazi'
	---@type YaziConfig | {}
	opts = {
		open_for_directories = true,
		keymaps = {
			show_help = "<f1>",
			change_working_directory = "`",
			grep_in_directory = "<c-s>",
			replace_in_directory = "<c-r>",
			cycle_open_buffers = "<f2>",
		},
		integrations = {
			grep_in_directory = function(directory)
				require("fzf-lua").grep({ cwd = directory, search = "" })
			end,
		},
	},
}
