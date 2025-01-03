return {
	{
		"nvim-telescope/telescope-frecency.nvim",
		version = "*",
		config = function()
			require("telescope").load_extension("frecency")
			vim.keymap.set(
				"n",
				"<leader>ff",
				"<cmd>Telescope frecency workspace=CWD<CR>",
				{ desc = "[F]recency [F]ile" }
			)
		end,
	},
}
