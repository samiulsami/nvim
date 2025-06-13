return {
	"folke/flash.nvim",
	event = "VeryLazy",
	--stylua: ignore
	keys = {
		{ "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
	},
	config = function()
		---@type Flash.Config
		local opts = {
			label = { uppercase = true, min_pattern_length = 1 },
			search = { max_length = 3 },
			highlight = { matches = false },
			jump = { autojump = true, nohlsearch = true },
			modes = {
				char = {
					multi_line = false,
					highlight = { backdrop = true },
					jump = { nohlsearch = true },
				},
			},
		}
		require("flash").setup(opts)
		vim.api.nvim_set_hl(0, "FlashLabel", { fg = "#ffff77", bold = true, italic = true })
	end,
}
