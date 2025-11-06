return {
	"nvim-mini/mini.nvim",
	lazy = false,
	config = function()
		require("mini.indentscope").setup({
			symbol = "│",
			draw = {
				delay = 0,
				animation = function()
					return 0
				end,
			},
			mappings = { object_scope = "", object_scope_with_border = "", goto_top = "", goto_bottom = "" },
			options = { border = "both", ident_at_cursor = false, try_as_border = true },
		})
		vim.api.nvim_set_hl(0, "MiniIndentScopeSymbol", { fg = "#009090", bold = true, italic = true })

		vim.api.nvim_set_hl(0, "MiniTablineFIll", { bold = true, italic = true })
	end,
}
