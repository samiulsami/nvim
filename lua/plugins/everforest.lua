return {
	{
		"sainnhe/everforest",
		priority = 1000,
		config = function()
			vim.cmd.colorscheme("everforest")
			vim.opt.termguicolors = true
			vim.g.everforest_enable_italic = true
			vim.g.everforest_background = "hard"
			vim.g.everforest_better_performance = 1
			vim.g.everforest_current_word = "bold"
			local bg_color = "#252525"
			vim.cmd("highlight Normal guibg=" .. bg_color) -- Set background for the normal window
			vim.cmd("highlight NormalNC guibg=" .. bg_color) -- Set background for the normal window
			vim.cmd("highlight StatusLine guibg=" .. "#151519") -- Set background for the status line
			vim.cmd("highlight EndOfBuffer guibg=" .. bg_color) -- Set EndOfBuffer background to match normal background
		end,
	},
}
