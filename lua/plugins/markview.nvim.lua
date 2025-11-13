return {
	"OXY2DEV/markview.nvim",
	lazy = false,
	config = function()
		vim.keymap.set("n", "<leader>mt", "<Cmd>Markview Toggle<CR>", { desc = "Toggle MarkView" })
	end,
}
