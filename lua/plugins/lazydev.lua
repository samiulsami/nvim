return {
	"folke/lazydev.nvim",
	ft = "lua",
	lazy = false,
	opts = {
		library = {
			{ path = "luvit-meta/library", words = { "vim%.uv" } },
		},
	},
}
