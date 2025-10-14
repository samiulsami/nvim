return {
	"nvim-mini/mini.nvim",
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
			options = {
				border = "both",
				ident_at_cursor = false,
				try_as_border = true,
			},
		})
	end,
}
