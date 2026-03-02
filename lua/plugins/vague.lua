return {
	"vague-theme/vague.nvim",
	lazy = false,
	priority = 1000,
	config = function()
		vim.cmd("colorscheme vague")
		require("utils.default_colors").set_colors()
	end,
}
