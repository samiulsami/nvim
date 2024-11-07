return {
	{
		"tpope/vim-fugitive",
		config = function()
			vim.keymap.set("n", "<leader>gg", ":Git<CR>", {})
			vim.keymap.set("n", "<leader>gd", ":Gvdiffsplit!<CR>", { desc = "[G]it [D]iff [S]plit" })
			vim.keymap.set("n", "<leader>gb", ":Git blame<CR>", { desc = "[G]it [B]lame" })
			vim.keymap.set(
				"n",
				"<leader>gm",
				":Git mergetool<CR>",
				{ noremap = true, silent = true, desc = "[G]it [M]erge [T]ool" }
			)
		end,
	},
}
