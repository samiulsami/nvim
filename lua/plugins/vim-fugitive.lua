return {
	{
		"tpope/vim-fugitive",
		config = function()
			-- stylua: ignore start
			vim.keymap.set("n", "<leader>gg", "<Cmd>Git<CR>", {})
			vim.keymap.set("n", "<leader>gd", "<Cmd>Gvdiffsplit!<CR>", { desc = "[G]it [D]iff [S]plit" })
			vim.keymap.set("n", "<leader>gm", "<Cmd>Git mergetool<CR>", { desc = "[G]it [M]ergetool" })
			vim.keymap.set("n", "<leader>gl", "<Cmd>Git log --oneline --full-history<CR>", { desc = "[G]it [L]og Oneline" })
			vim.keymap.set("n", "<leader>gA", "<Cmd>Git commit --amend --no-edit --signoff<CR>", { desc = "[G]it Commit [A]mend" })
			vim.keymap.set("n", "<leader>gL", "<Cmd>Git log<CR>", { desc = "[G]it [L]og" })
			vim.keymap.set("n", "<leader>gc", "<Cmd>Git commit --signoff<CR>", { desc = "[G]it [C]omit" })
			-- stylua: ignore end
		end,
	},
}
