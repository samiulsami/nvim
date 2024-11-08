return {
	{
		"rcarriga/nvim-notify",
		config = function()
			vim.notify = require("notify") -- Set as the default notify handler
			require("notify").setup({
				stages = "fade",
				timeout = 1500,
				background_colour = "#000000",
			})
		end,
		event = "VeryLazy", -- Load after other plugins
	},
}
