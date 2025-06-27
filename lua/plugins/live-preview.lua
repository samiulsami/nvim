return {
	"brianhuster/live-preview.nvim",
	dependencies = {
		"ibhagwan/fzf-lua",
	},
	config = function()
		vim.keymap.set(
			"n",
			"<leader>mp",
			"<Cmd>LivePreview start<CR>",
			{ noremap = true, silent = true, desc = "Live Preview [M]arkdown" }
		)
	end,
}
