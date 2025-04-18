return {
	{
		"supermaven-inc/supermaven-nvim",
		config = function()
			require("supermaven-nvim").setup({
				keymaps = {
					accept_suggestion = "<c-j>",
					clear_suggestion = "<c-h>",
					accept_word = "<c-k>",
				},
				log_level = "off",
			})
		end,
	},
}
