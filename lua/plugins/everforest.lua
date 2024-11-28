return {
	{
		"sainnhe/everforest",
		priority = 1000,
		config = function()
			vim.cmd.colorscheme("everforest")
			vim.g.everforest_enable_italic = true
			vim.g.everforest_background = "hard"
			vim.g.everforest_better_performance = 1
			vim.g.everforest_current_word = "bold"
		end,
	},
}
