return {
	"tpope/vim-sleuth",
	config = function()
		vim.keymap.set("n", "<leader>vs", "<Cmd>Sleuth<CR>", { noremap = true, silent = true, desc = "[V]im [S]leuth" })
	end,
}
