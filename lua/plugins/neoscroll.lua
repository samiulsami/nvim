return {
	"karb94/neoscroll.nvim",
	config = function()
		require("neoscroll").setup({
			duration_multiplier = 0.1, -- Global duration multiplier
			easing = "sine", -- Default easing function
		})
	end,
}
