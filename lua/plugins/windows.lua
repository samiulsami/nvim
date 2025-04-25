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

			vim.keymap.set("n", "<leader>z", ":WindowsMaximize<CR>", { desc = "Toggle Windows" })
			vim.keymap.set("n", "<leader>=", ":WindowsEqualize<CR>", { desc = "Equalize Windows" })
			vim.keymap.set("n", "<leader>O", ":only<CR>", { desc = "[O]nly Current Window" })
		end,
	},
}
