return {
	{
		"akinsho/toggleterm.nvim",
		--stylua: ignore
		config = function()
			require("toggleterm").setup({
				size = 13,
				open_mapping = [[<F12>]],

				autochdir = true,
				start_in_insert = true,
				persist_size = true,
				persist_mode = false,
				insert_mappings = true, -- whether or not the open mapping applies in insert mode
				terminal_mappings = true, -- whether or not the open mapping applies in the opened terminals
				close_on_exit = true, -- close the terminal window when the process exits
				clear_env = false,
				hide_numbers = false,
				direction = "float",
				float_opts = {
					border = { " ", "─", " ", " ", " ", " ", " ", " " },
					winblend = 13,
					width = 999999,
					height = 13,
					row = 999999,
				},

				auto_scroll = true,
				shell = vim.o.shell,
			})
		end,
	},
}
