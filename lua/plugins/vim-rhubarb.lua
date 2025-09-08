return {
	"tpope/vim-rhubarb",
	dependencies = { "tpope/vim-fugitive" },
	config = function()
		vim.keymap.set({ "n" }, "<leader>G", "<cmd>GBrowse<CR>", { silent = true, noremap = true, desc = "Open the current line in Github" })
		vim.keymap.set({ "v" }, "<leader>G", function()
			local start_line = vim.fn.line("v")
			local end_line = vim.fn.line(".")
			if end_line < start_line then
				start_line, end_line = end_line, start_line
			end
			vim.cmd(start_line .. "," .. end_line .. "GBrowse")
		end, { silent = true, noremap = true, desc = "Open the current selection in Github" })
	end,
}
