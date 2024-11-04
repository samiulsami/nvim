return {
	{
		"MeanderingProgrammer/render-markdown.nvim",
		dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" }, -- if you prefer nvim-web-devicons
		---@module 'render-markdown'
		---@type render.md.UserConfig
		opts = {},
		config = function()
			vim.keymap.set(
				"n",
				"<leader>md",
				":RenderMarkdown toggle<CR>",
				{ silent = true, noremap = true, desc = "Toggle [M]ark[D]own render" }
			)
		end,
	},
}
