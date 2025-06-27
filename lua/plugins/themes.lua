local set_default_colors = function()
	vim.api.nvim_set_hl(0, "LspReferenceText", { bg = "#1a1a1a", bold = true })
	vim.api.nvim_set_hl(0, "LspReferenceRead", { bg = "#1a1a1a", bold = true })
	vim.api.nvim_set_hl(0, "LspReferenceWrite", { bg = "#1a1a1a", bold = true })

	vim.api.nvim_set_hl(0, "DiagnosticVirtualTextWarn", { fg = "#d7af5f", bg = "#2a2b2e", bold = true })
	vim.api.nvim_set_hl(0, "DiagnosticVirtualTextError", { fg = "#d75f5f", bg = "#2a2b2e", bold = true })
	vim.api.nvim_set_hl(0, "DiagnosticVirtualTextInfo", { fg = "#5f87d7", bg = "#2a2b2e", bold = true })
	vim.api.nvim_set_hl(0, "DiagnosticVirtualTextHint", { fg = "#5fd7d7", bg = "#2a2b2e", bold = true })

	vim.api.nvim_set_hl(0, "SymbolUsageRounding", { italic = true })
	vim.api.nvim_set_hl(0, "SymbolUsageContent", { fg = "#6a6a6a", italic = true })
	vim.api.nvim_set_hl(0, "SymbolUsageRef", { fg = "#6f5a5a", italic = true })
	vim.api.nvim_set_hl(0, "SymbolUsageImpl", { fg = "#5a5a6f", italic = true })
	vim.api.nvim_set_hl(0, "Comment", { bg = "none", fg = "#6f7b69" })

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
			-- vim.g.everforest_transparent_background = 2
			--
			-- vim.g.everforest_background = "hard"
			-- vim.g.everforest_better_performance = 1
			-- vim.cmd.colorscheme("everforest")
			-- local buffer_bg_color = "#1a1b1e"
			-- vim.api.nvim_set_hl(0, "Normal", { bg = buffer_bg_color })
			-- vim.api.nvim_set_hl(0, "NormalNC", { bg = buffer_bg_color })
			-- vim.api.nvim_set_hl(0, "EndOfBuffer", { bg = buffer_bg_color })
			-- set_default_colors()
			-- vim.api.nvim_set_hl(0, "CursorLine", { bold = true, bg = "#252525" })
			-- vim.api.nvim_set_hl(0, "CursorColumn", { bold = true, bg = "#252525" })
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
			-- vim.api.nvim_set_hl(0, "NoiceCmdlinePopupBorder", { fg = "#ffcc77", bold = true })
			--
			-- local buffer_bg_color = "#1a1b1e"
			-- vim.api.nvim_set_hl(0, "Normal", { bg = buffer_bg_color })
			-- vim.api.nvim_set_hl(0, "NormalNC", { bg = buffer_bg_color })
			-- vim.api.nvim_set_hl(0, "EndOfBuffer", { bg = buffer_bg_color })
		end,
	},
	{
		"folke/tokyonight.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			require("tokyonight").setup({
				transparent = true,
				styles = {
					sidebars = "transparent",
					floats = "transparent",
				},
			})
			vim.cmd.colorscheme("tokyonight-night")
			set_default_colors()
			vim.api.nvim_set_hl(0, "NoiceCmdlinePopupBorder", { fg = "#ffcc77", bold = true })
			vim.api.nvim_set_hl(0, "CursorLine", { bold = true, bg = "#1a1a1a" })
			vim.api.nvim_set_hl(0, "CursorColumn", { bold = true, bg = "#1a1a1a" })
		end,
	},
}
