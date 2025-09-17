return {
	"tpope/vim-sleuth",
	lazy = false,
	config = function()
		vim.api.nvim_create_autocmd("BufEnter", {
			pattern = { "*" },
			callback = function()
				if vim.bo.modifiable then
					vim.cmd("silent! Sleuth")
				end
			end,
		})

		vim.keymap.set("n", "<leader>vs", "<Cmd>Sleuth<CR>", { noremap = true, silent = true, desc = "Run vim-sleuth" })
	end,
}
