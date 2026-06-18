---@type PluginSpec
return {
	src = "https://github.com/tjgao/quickbuf.nvim",
	config = function()
		require("quickbuf").setup({
			include_special = false,
			alternate_key = "<A-s>",
			alternate_key_display = "<A-s>",
			alternate_without_label = false,
			show_icons = false,
			picker = {
				move_up_key = "<C-p>",
				move_down_key = "<C-n>",
				toggle_pin_key = "p",
			},
			persistence = {
				enabled = true,
			},
		})
		vim.keymap.set("n", "<A-s>", "<cmd>QuickBuf<CR>", { desc = "QuickBuf" })
		vim.keymap.set("n", "<A-w>", "<cmd>QuickBufPinToggle<CR>", { desc = "Pin toggle" })
		vim.keymap.set("n", "<A-q>", "<cmd>QuickBufPrevPinned<CR>", { desc = "Prev pinned buffer" })
		vim.keymap.set("n", "<A-e>", "<cmd>QuickBufNextPinned<CR>", { desc = "Next pinned buffer" })
	end,
}
