return {
	"SmiteshP/nvim-navic",
	config = function()
		require("nvim-navic").setup({
			lsp = {
				auto_attach = true,
				preference = { "gopls", "lua", "clangd" },
			},
			highlight = true,
			depth_limit_indicator = "...",
		})
		vim.o.winbar = "%{%v:lua.require'nvim-navic'.get_location()%}"
	end,
}
