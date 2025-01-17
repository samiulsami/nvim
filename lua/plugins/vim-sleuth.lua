return {
	"tpope/vim-sleuth",
	config = function()
		vim.keymap.set("n", "<leader>vs", ":Sleuth<CR>", { noremap = true, silent = true, desc = "[V]im [S]leuth" })
	end,
}
