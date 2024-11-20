return {
	{
		"anuvyklack/windows.nvim",
		dependencies = {
			"anuvyklack/middleclass",
		},
		config = function()
			require("windows").setup({
				autowidth = {
					enable = false,
				},
				ignore = {},
				animation = {
					enable = false,
				},
			})

			vim.keymap.set("n", "<M-CR>", ":WindowsMaximize<CR>", { desc = "Toggle Windows" })
			vim.keymap.set("n", "<C-w>_", ":WindowsMaximizeVertically<CR>", { desc = "Vertically Maximize Windows" })
			vim.keymap.set(
				"n",
				"<c-w>|",
				":WindowsMaximizeHorizontally<CR>",
				{ desc = "Horizontally Maximize Windows" }
			)
			vim.keymap.set("n", "<c-w>=", ":WindowsEqualize<CR>", { desc = "Equalize Windows" })
		end,
	},
}
