return {
	"tpope/vim-fugitive",
	lazy = false,
	config = function()
		vim.keymap.set("n", "<leader>gg", "<Cmd>Git<CR>", { desc = "[G]it Status" })
		vim.keymap.set("n", "<leader>gl", "<Cmd>Git log --oneline --full-history<CR>", { desc = "[G]it [L]og Oneline" })
		vim.keymap.set(
			"n",
			"<leader>gA",
			"<Cmd>silent Git commit --amend --no-edit --signoff<CR>",
			{ desc = "[G]it Commit [A]mend" }
		)
		vim.keymap.set("n", "<leader>gL", "<Cmd>Git log<CR>", { desc = "[G]it [L]og" })
		vim.keymap.set("n", "<leader>gc", "<Cmd>silent Git commit --signoff<CR>", { desc = "[G]it [C]omit" })
		vim.keymap.set("n", "<leader>gb", "<Cmd>silent Git blame<CR>", { desc = "[G]it [B]lame" })
	end,
}
