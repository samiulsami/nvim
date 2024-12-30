return {
	{
		"jinh0/eyeliner.nvim",
		config = function()
			require("eyeliner").setup({
				highlight_on_key = true,
				dim = true,
				max_length = 1000,
			})
			-- vim.api.nvim_set_hl(0, "EyelinerPrimary", { fg = "#ff0000", bold = true, underline = true })
			-- vim.api.nvim_set_hl(0, "EyelinerSecondary", { fg = "#00ff00", bold = true, underline = true })
		end,
	},
}
