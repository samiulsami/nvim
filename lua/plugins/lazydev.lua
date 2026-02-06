return {
	spec = {
		{ src = "https://github.com/folke/lazydev.nvim" },
	},
	config = function()
		require("lazydev").setup({
			library = {
				{ path = "luvit-meta/library", words = { "vim%.uv" } },
			},
		})
	end,
}
