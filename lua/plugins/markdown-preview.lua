return {
	"iamcco/markdown-preview.nvim",
	cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
	ft = { "markdown" },
	build = "cd app && npm install",

	config = function()
		vim.g.mkdp_auto_close = 0
		vim.g.mkdp_combine_preview = 0
		vim.keymap.set("n", "<leader>mp", ":MarkdownPreview<CR>", { noremap = true, silent = true })
	end,
}
