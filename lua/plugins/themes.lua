local set_default_colors = function()
	local lspref_color = "#2d2f41"
	vim.api.nvim_set_hl(0, "LspReferenceText", { bg = lspref_color, bold = true, underline = true })
	vim.api.nvim_set_hl(0, "LspReferenceRead", { bg = lspref_color, bold = true, underline = true })
	vim.api.nvim_set_hl(0, "LspReferenceWrite", { bg = lspref_color, bold = true, underline = true })

	vim.api.nvim_set_hl(0, "SymbolUsageRounding", { italic = true })
	vim.api.nvim_set_hl(0, "SymbolUsageContent", { fg = "#6a6a6a", italic = true })
	vim.api.nvim_set_hl(0, "SymbolUsageRef", { fg = "#6f5a5a", italic = true })
	vim.api.nvim_set_hl(0, "SymbolUsageImpl", { fg = "#5a5a6f", italic = true })
	vim.api.nvim_set_hl(0, "Comment", { bg = "none", fg = "#6f7b69" })
	vim.api.nvim_set_hl(0, "LspInlayHint", { fg = "#5f6b68", bg = "#1f1b18", bold = true, italic = true })

	vim.api.nvim_set_hl(0, "NormalFloat", { bg = "#2d2d3c", bold = true, italic = true })
	vim.api.nvim_set_hl(0, "BlinkCmpMenu", { link = "NormalFloat" })
	vim.api.nvim_set_hl(0, "BlinkCmpDoc", { link = "NormalFloat" })
	vim.api.nvim_set_hl(0, "DiagnosticFloatingError", { link = "NormalFloat" })
	vim.api.nvim_set_hl(0, "DiagnosticFloatingWarn", { link = "NormalFloat" })
	vim.api.nvim_set_hl(0, "DiagnosticFloatingInfo", { link = "NormalFloat" })
	vim.api.nvim_set_hl(0, "DiagnosticFloatingHint", { link = "NormalFloat" })
	vim.api.nvim_set_hl(0, "DiagnosticFloatingOk", { link = "NormalFloat" })
end

return {
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
			vim.api.nvim_set_hl(0, "CursorLine", { bold = true, bg = "#1f1f2a" })
			vim.api.nvim_set_hl(0, "CursorColumn", { bold = true, bg = "#1f1f2a" })
			vim.api.nvim_set_hl(0, "TablineFIll", { bold = true, italic = true })

			-- local buffer_bg_color = "#191a1c"
			-- vim.api.nvim_set_hl(0, "Normal", { bg = buffer_bg_color })
			-- vim.api.nvim_set_hl(0, "NormalNC", { bg = buffer_bg_color })
			-- vim.api.nvim_set_hl(0, "EndOfBuffer", { bg = buffer_bg_color })
		end,
	},
}
