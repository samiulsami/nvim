return {
	{
		"OXY2DEV/markview.nvim",
		lazy = false, -- Recommended
		-- ft = "markdown" -- If you decide to lazy-load anyway

		dependencies = {
			"nvim-treesitter/nvim-treesitter",
			"nvim-tree/nvim-web-devicons",
		},
		config = function()
			require("markview").setup({
				highlight_groups = "dark",
			})

			vim.keymap.set(
				"n",
				"<leader>ms",
				":Markview splitToggle<CR>",
				{ noremap = true, silent = true, desc = "[M]arkview [S]plitToggle" }
			)

			vim.keymap.set(
				"n",
				"<leader>mt",
				":Markview toggle<CR>",
				{ noremap = true, silent = true, desc = "[M]arkview [T]oggle" }
			)
		end,
	},
}
