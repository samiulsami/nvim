return {
	{
		"akinsho/toggleterm.nvim",
		config = function()
			require("toggleterm").setup({
				config = true,
				size = 12, -- Height of the bottom terminal split
				open_mapping = [[<F12>]], -- Key to toggle terminal
				hide_numbers = true,
				shade_terminals = true,
				shading_factor = 2,
				start_in_insert = true,
				insert_mappings = true,
				terminal_mappings = true,
				persist_size = false,
				direction = "horizontal", -- Horizontal split at the bottom
				close_on_exit = true,
				shell = vim.o.shell,
			})
		end,
	},
}
