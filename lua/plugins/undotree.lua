return {
	{
		"mbbill/undotree",
		config = function()
			vim.g.undotree_RelativeTimestamp = false
			vim.keymap.set("n", "<leader>u", ":UndotreeToggle<CR>", { desc = "Toggle UndoTree" })
		end,
	},
}
