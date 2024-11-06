-- TODO: Learn tmux and remove this
return {
	{
		"akinsho/toggleterm.nvim",
		config = function()
			require("toggleterm").setup({
				size = 13,
				open_mapping = [[<F12>]],
				on_open = function(term)
					vim.cmd("set number")
					vim.cmd("set relativenumber")
				end,

				autochdir = true,
				start_in_insert = true,
				persist_size = false,
				persist_mode = false,
				insert_mappings = true, -- whether or not the open mapping applies in insert mode
				terminal_mappings = true, -- whether or not the open mapping applies in the opened terminals
				close_on_exit = true, -- close the terminal window when the process exits
				clear_env = false,
				hide_numbers = false,
				direction = "float",
				auto_scroll = true,
				shell = vim.o.shell,
			})

			vim.keymap.set("t", "<C-q>", "<C-\\><C-n>", { desc = "Exit terminal mode" })
		end,
	},
}
