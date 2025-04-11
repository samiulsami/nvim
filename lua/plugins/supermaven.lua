return {
	{
		"supermaven-inc/supermaven-nvim",
		config = function()
			require("supermaven-nvim").setup({
				keymaps = {
					accept_suggestion = "<c-j>",
					clear_suggestion = "<c-]>",
					accept_word = "<A-k>",
				},
				log_level = "off",
			})
		end,
	},
}
