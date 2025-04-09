return {
	"karb94/neoscroll.nvim",
	config = function()
		local neoscroll = require("neoscroll")
		neoscroll.setup({
			duration_multiplier = 0.1,
			easing = "sine",
			post_hook = function()
				vim.cmd("normal! zz")
			end,
			mappings = {
				"<C-u>",
				"<C-d>",
				"zz",
			},
		})
	end,
}
