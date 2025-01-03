return {
	{
		"nvim-telescope/telescope-frecency.nvim",
		dependencies = {
			"nvim-telescope/telescope.nvim",
		},
		version = "*",
		config = function()
			require("telescope").load_extension("frecency")
			vim.keymap.set(
				"n",
				"<leader>ff",
				":Telescope frecency workspace=CWD<CR><BS>",
				{ desc = "[F]recency [F]ile" }
			)
		end,
	},
}
