local set_default_colors = function()
	vim.api.nvim_set_hl(0, "LspReferenceText", { bg = "#1a1a1a", bold = true })
	vim.api.nvim_set_hl(0, "LspReferenceRead", { bg = "#1a1a1a", bold = true })
	vim.api.nvim_set_hl(0, "LspReferenceWrite", { bg = "#1a1a1a", bold = true })

	vim.api.nvim_set_hl(0, "DiagnosticVirtualTextWarn", { fg = "#d7af5f", bg = "#2a2b2e", bold = true })
	vim.api.nvim_set_hl(0, "DiagnosticVirtualTextError", { fg = "#d75f5f", bg = "#2a2b2e", bold = true })
	vim.api.nvim_set_hl(0, "DiagnosticVirtualTextInfo", { fg = "#5f87d7", bg = "#2a2b2e", bold = true })
	vim.api.nvim_set_hl(0, "DiagnosticVirtualTextHint", { fg = "#5fd7d7", bg = "#2a2b2e", bold = true })

	vim.api.nvim_set_hl(0, "SymbolUsageRounding", { italic = true })
	vim.api.nvim_set_hl(0, "SymbolUsageContent", { fg = "#aaaaaa", italic = true })
	vim.api.nvim_set_hl(0, "SymbolUsageRef", { fg = "#ff6666", italic = true })
	vim.api.nvim_set_hl(0, "SymbolUsageImpl", { fg = "#6666ff", italic = true })
	vim.api.nvim_set_hl(0, "LspInlayHint", { fg = "#5f6b68", bg = "#1f1b18", bold = true, italic = true })

	vim.api.nvim_set_hl(0, "WinBar", { bold = true })
	vim.api.nvim_set_hl(0, "WinBarNC", { bold = true })
end

return {
	{
		"sainnhe/everforest",
		lazy = false,
		priority = 1000,
		config = function()
			vim.g.everforest_background = "hard"
			vim.g.everforest_better_performance = 1
			vim.cmd.colorscheme("everforest")
			local buffer_bg_color = "#1a1b1e"
			vim.api.nvim_set_hl(0, "Normal", { bg = buffer_bg_color })
			vim.api.nvim_set_hl(0, "NormalNC", { bg = buffer_bg_color })
			vim.api.nvim_set_hl(0, "EndOfBuffer", { bg = buffer_bg_color })
			set_default_colors()
		end,
	},

	{
		"sainnhe/gruvbox-material",
		lazy = false,
		priority = 1000,
		config = function()
			-- vim.g.gruvbox_material_enable_italic = true
			-- vim.g.gruvbox_material_background = "hard" -- Options: 'hard', 'soft', 'medium'
			-- vim.g.gruvbox_material_transparent_background = 2
			-- vim.cmd.colorscheme("gruvbox-material")
			-- set_default_colors()
			-- vim.api.nvim_set_hl(0, "NoiceCmdlinePopupBorder", { fg = "#aacc99", bold = true })
		end,
	},

	{
		"vague2k/vague.nvim",
		config = function()
			require("vague").setup({
				transparent = true,
			})
			-- vim.cmd.colorscheme("vague")
			-- set_default_colors()
			-- vim.api.nvim_set_hl(0, "NoiceCmdlinePopupBorder", { fg = "#ffccee", bold = true })
		end,
	},

	{
		"rose-pine/neovim",
		name = "rose-pine",
		lazy = false,
		priority = 1000,
		config = function()
			require("rose-pine").setup({
				dark_variant = "main",
				disable_background = true,
				styles = {
					transparency = true,
				},
			})
			-- vim.cmd.colorscheme("rose-pine")
			-- set_default_colors()
			-- vim.api.nvim_set_hl(0, "NoiceCmdlinePopupBorder", { fg = "#ffccaa", bold = true })
		end,
	},

	{
		"projekt0n/github-nvim-theme",
		name = "github-theme",
		lazy = false, -- make sure we load this during startup if it is your main colorscheme
		priority = 1000, -- make sure to load this before all the other start plugins
		config = function()
			require("github-theme").setup({
				options = {
					transparent = true,
				},
			})
			-- vim.cmd.colorscheme("github_dark")
			-- set_default_colors()
		end,
	},

	{
		"drewxs/ash.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			require("ash").setup({
				transparent = true,
			})
			-- vim.cmd.colorscheme("ash")
			-- set_default_colors()
		end,
	},
	{

		"sainnhe/sonokai",
		lazy = false,
		priority = 1000,
		config = function()
			-- vim.g.sonokai_transparent_background = 2
			-- vim.cmd.colorscheme("sonokai")
			-- set_default_colors()
		end,
	},
}
