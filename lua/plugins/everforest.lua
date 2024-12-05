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

			local bg_color = "#1e1f22"
			vim.api.nvim_set_hl(0, "Normal", { bg = bg_color }) -- Set background for the normal window
			vim.api.nvim_set_hl(0, "NormalNC", { bg = bg_color }) -- Set background for the normal window
			vim.api.nvim_set_hl(0, "EndOfBuffer", { bg = bg_color }) -- Set EndOfBuffer background to match normal background
		end,
	},
}
