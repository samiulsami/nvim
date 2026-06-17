---@type PluginSpec
return {
	src = "https://github.com/tjgao/quickbuf.nvim",
	config = function()
		require("quickbuf").setup()
		vim.keymap.set("n", "<Tab>", "<cmd>QuickBuf<CR>", { desc = "QuickBuf" })
		vim.keymap.set("n", "<leader>qt", "<cmd>QuickBufPinToggle<CR>", { desc = "Pin toggle" })
		vim.keymap.set("n", "<S-h>", "<cmd>QuickBufPrevPinned<CR>", { desc = "Prev pinned buffer" })
		vim.keymap.set("n", "<S-l>", "<cmd>QuickBufNextPinned<CR>", { desc = "Next pinned buffer" })
	end,
}
