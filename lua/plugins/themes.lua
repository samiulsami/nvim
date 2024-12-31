return {
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
			vim.g.everforest_background = "hard"
			vim.g.everforest_better_performance = 1
			local setup_highlights = function()
				vim.api.nvim_set_hl(0, "EyelinerPrimary", { fg = "#ff0000", underline = true })
				vim.api.nvim_set_hl(0, "EyelinerSecondary", { fg = "#00ff00", underline = true })
				vim.api.nvim_set_hl(0, "LeapBackdrop", { link = "Comment" })
				vim.api.nvim_set_hl(0, "LeapLabel", { fg = "#ff0000", bold = true })
				vim.api.nvim_set_hl(0, "LspReferenceText", { underline = true })
				vim.api.nvim_set_hl(0, "LspReferenceRead", { underline = true })
				vim.api.nvim_set_hl(0, "LspReferenceWrite", { underline = true })

				local bg_color = "#0e0f12"
				vim.api.nvim_set_hl(0, "NeoTreeNormal", { bg = bg_color })
				vim.api.nvim_set_hl(0, "NeoTreeNormalNC", { bg = bg_color })
				vim.api.nvim_set_hl(0, "NeoTreeEndOfBuffer", { bg = bg_color })
				vim.api.nvim_set_hl(0, "MarkviewHeading1", { fg = "#a89984", bg = "#3c3836", bold = true })
				vim.api.nvim_set_hl(0, "MarkviewHeading1Sign", { fg = "#7c6f64", bg = "#3c3836", bold = true })

				vim.api.nvim_set_hl(0, "MarkviewHeading2", { fg = "#bdae93", bg = "#323d43", bold = true })
				vim.api.nvim_set_hl(0, "MarkviewHeading2Sign", { fg = "#665c54", bg = "#323d43", bold = true })

				vim.api.nvim_set_hl(0, "MarkviewHeading3", { fg = "#d8a657", bg = "#45493d", bold = true })
				vim.api.nvim_set_hl(0, "MarkviewHeading3Sign", { fg = "#a17e5a", bg = "#45493d", bold = true })

				vim.api.nvim_set_hl(0, "MarkviewHeading4", { fg = "#89b482", bg = "#374247", bold = true })
				vim.api.nvim_set_hl(0, "MarkviewHeading4Sign", { fg = "#5a7a58", bg = "#374247", bold = true })

				vim.api.nvim_set_hl(0, "MarkviewHeading5", { fg = "#7daea3", bg = "#3e4c4f", bold = true })
				vim.api.nvim_set_hl(0, "MarkviewHeading5Sign", { fg = "#4d696d", bg = "#3e4c4f", bold = true })

				vim.api.nvim_set_hl(0, "MarkviewHeading6", { fg = "#d3869b", bg = "#4a3d4d", bold = true })
				vim.api.nvim_set_hl(0, "MarkviewHeading6Sign", { fg = "#935f73", bg = "#4a3d4d", bold = true })
				vim.api.nvim_set_hl(0, "MarkviewCode", { bg = "#2f2f2f", bold = true })

				vim.api.nvim_set_hl(0, "SymbolUsageRounding", { italic = true })
				vim.api.nvim_set_hl(0, "SymbolUsageContent", { fg = "#aaaaaa", italic = true })
				vim.api.nvim_set_hl(0, "SymbolUsageRef", { fg = "#ff6666", italic = true })
				vim.api.nvim_set_hl(0, "SymbolUsageImpl", { fg = "#6666ff", italic = true })
			end

			local setup_default_theme = function()
				vim.cmd.colorscheme("everforest")

				local bg_color = "#1e1f22"
				vim.api.nvim_set_hl(0, "Normal", { bg = bg_color })
				vim.api.nvim_set_hl(0, "NormalNC", { bg = bg_color })
				vim.api.nvim_set_hl(0, "EndOfBuffer", { bg = bg_color })
				setup_highlights()
			end

			local setup_alternate_theme = function()
				vim.cmd.colorscheme("darkvoid")
				setup_highlights()
			end

			local alternate_theme = true
			setup_alternate_theme()

			vim.keymap.set("n", "<leader>ct", function()
				vim.cmd.colorscheme("default")
				alternate_theme = not alternate_theme
				if alternate_theme then
					setup_alternate_theme()
				else
					setup_default_theme()
				end
			end, { desc = "[C]hange [T]heme" })
		end,
	},
}
