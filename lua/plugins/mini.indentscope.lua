return {
	"nvim-mini/mini.indentscope",
	config = function()
		local mini_indentscope = require("mini.indentscope")
		mini_indentscope.setup({
			symbol = "│",
			draw = {
				delay = 0,
				animation = mini_indentscope.gen_animation.none(),
			},
			mappings = {
				object_scope = "",
				object_scope_with_border = "",
				goto_top = "[s",
				goto_bottom = "]s",
			},
			options = {
				border = "both",
				indent_at_cursor = true,
				try_as_border = true,
			},
		})
	end,
}
