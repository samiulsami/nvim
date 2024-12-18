return {
	{
		"OXY2DEV/markview.nvim",
		lazy = false, -- Recommended
		-- ft = "markdown" -- If you decide to lazy-load anyway

		dependencies = {
			"nvim-treesitter/nvim-treesitter",
			"nvim-tree/nvim-web-devicons",
		},
		config = function()
			local presets = require("markview.presets")
			require("markview").setup({
				highlight_groups = "dark",
				checkboxes = presets.checkboxes.nerd,
				headings = presets.headings.arrowed,
				horizontal_rules = presets.horizontal_rules.thin,
			})

			vim.keymap.set(
				"n",
				"<leader>ms",
				":Markview splitToggle<CR>",
				{ noremap = true, silent = true, desc = "[M]arkview [S]plitToggle" }
			)

			vim.keymap.set(
				"n",
				"<leader>mt",
				":Markview toggle<CR>",
				{ noremap = true, silent = true, desc = "[M]arkview [T]oggle" }
			)
			-- Heading 1: Softer brown on muted dark beige background
			vim.api.nvim_set_hl(0, "MarkviewHeading1", { fg = "#a89984", bg = "#3c3836", bold = true })
			vim.api.nvim_set_hl(0, "MarkviewHeading1Sign", { fg = "#7c6f64", bg = "#3c3836", bold = true })

			-- Heading 2: Muted beige on soft greenish-gray background
			vim.api.nvim_set_hl(0, "MarkviewHeading2", { fg = "#bdae93", bg = "#323d43", bold = true })
			vim.api.nvim_set_hl(0, "MarkviewHeading2Sign", { fg = "#665c54", bg = "#323d43", bold = true })

			-- Heading 3: Golden tone on slightly darker greenish background
			vim.api.nvim_set_hl(0, "MarkviewHeading3", { fg = "#d8a657", bg = "#45493d", bold = true })
			vim.api.nvim_set_hl(0, "MarkviewHeading3Sign", { fg = "#a17e5a", bg = "#45493d", bold = true })

			-- Heading 4: Softer green on muted blue-green background
			vim.api.nvim_set_hl(0, "MarkviewHeading4", { fg = "#89b482", bg = "#374247", bold = true })
			vim.api.nvim_set_hl(0, "MarkviewHeading4Sign", { fg = "#5a7a58", bg = "#374247", bold = true })

			-- Heading 5: Soft teal on darker teal-gray background
			vim.api.nvim_set_hl(0, "MarkviewHeading5", { fg = "#7daea3", bg = "#3e4c4f", bold = true })
			vim.api.nvim_set_hl(0, "MarkviewHeading5Sign", { fg = "#4d696d", bg = "#3e4c4f", bold = true })

			-- Heading 6: Subtle pink/mauve on dark mauve-gray background
			vim.api.nvim_set_hl(0, "MarkviewHeading6", { fg = "#d3869b", bg = "#4a3d4d", bold = true })
			vim.api.nvim_set_hl(0, "MarkviewHeading6Sign", { fg = "#935f73", bg = "#4a3d4d", bold = true })
		end,
	},
}
