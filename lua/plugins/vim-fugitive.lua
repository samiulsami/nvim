return {
	{
		"tpope/vim-fugitive",
		config = function()
			-- stylua: ignore start
			vim.keymap.set("n", "<leader>gg", "<Cmd>Git<CR>", {})
			vim.keymap.set("n", "<leader>gl", "<Cmd>Git log --oneline --full-history<CR>", { desc = "[G]it [L]og Oneline" })
			vim.keymap.set("n", "<leader>gA", "<Cmd>silent Git commit --amend --no-edit --signoff<CR>", { desc = "[G]it Commit [A]mend" })
			vim.keymap.set("n", "<leader>gL", "<Cmd>Git log<CR>", { desc = "[G]it [L]og" })
			vim.keymap.set("n", "<leader>gc", "<Cmd>silent Git commit --signoff<CR>", { desc = "[G]it [C]omit" })
			-- stylua: ignore end
		end,
	},
}
