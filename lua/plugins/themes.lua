return {
	-- {
	-- 	"slugbyte/lackluster.nvim",
	-- 	lazy = false,
	-- 	priority = 1000,
	-- 	init = function()
	-- 		vim.cmd.colorscheme("lackluster-night")
	-- 	end,
	-- },
	--
	-- {
	-- 	"vague2k/vague.nvim",
	-- 	config = function()
	-- 		require("vague").setup({
	-- 			-- optional configuration here
	-- 		})
	-- 	end,
	-- },
	-- {
	-- 	"DanielEliasib/sweet-fusion",
	-- 	name = "sweet-fusion",
	-- 	priority = 1000,
	-- 	opts = {
	-- 		-- Set transparent background
	-- 		transparency = false,
	-- 		dim_inactive = true,
	-- 	},
	-- },

	{
		"sainnhe/everforest",
		lazy = false,
		priority = 1000,

		dependencies = {
			{
				"aliqyan-21/darkvoid.nvim",
				config = function()
					require("darkvoid").setup({
						transparent = false,
						glow = true,
						show_end_of_buffer = true,
					})
				end,
			},
		},
		config = function()
			local setup_default_theme = function()
				vim.cmd.colorscheme("everforest")
				vim.g.everforest_enable_italic = true
				vim.g.everforest_background = "hard"
				vim.g.everforest_better_performance = 1
				vim.g.everforest_current_word = "bold"

				local bg_color = "#1e1f22"
				vim.api.nvim_set_hl(0, "Normal", { bg = bg_color }) -- Set background for the normal window
				vim.api.nvim_set_hl(0, "NormalNC", { bg = bg_color }) -- Set background for the normal window
				vim.api.nvim_set_hl(0, "EndOfBuffer", { bg = bg_color }) -- Set EndOfBuffer background to match normal background
			end

			local setup_alternate_theme = function()
				vim.cmd.colorscheme("darkvoid")
				vim.api.nvim_set_hl(0, "EyelinerPrimary", { fg = "#ff0000", bold = true, underline = true })
				vim.api.nvim_set_hl(0, "EyelinerSecondary", { fg = "#00ff00", bold = true, underline = true })

				vim.api.nvim_set_hl(0, "LeapLabel", { fg = "#ff0000", bold = true, underline = true })
			end

			local alternate_theme = true
			setup_alternate_theme()

			vim.keymap.set("n", "<leader>ct", function()
				alternate_theme = not alternate_theme
				vim.cmd.colorscheme("default")
				if alternate_theme then
					setup_alternate_theme()
				else
					setup_default_theme()
				end
			end, { desc = "[C]hange [T]heme" })
		end,
	},
}
