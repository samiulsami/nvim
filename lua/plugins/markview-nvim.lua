return {
	spec = {
		{ src = "https://github.com/OXY2DEV/markview.nvim" },
	},
	config = function()
		vim.keymap.set("n", "<leader>mt", "<Cmd>Markview Toggle<CR>", { desc = "Toggle MarkView" })
	end,
}
