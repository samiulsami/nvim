return {
	"folke/flash.nvim",
	event = "VeryLazy",
	---@type Flash.Config
	opts = {
		label = {
			min_pattern_length = 1,
		},
		highlight = {
			matches = false,
		},
	},
	--stylua: ignore
	keys = {
		{ "s", mode = {"n"}, function() require("flash").jump() end, desc = "Flash" },
	},
}
