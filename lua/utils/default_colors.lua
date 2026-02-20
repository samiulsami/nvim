local M = {}
M.set_colors = function()
	vim.api.nvim_set_hl(0, "CursorLine", { bold = true, bg = "#1b1b1b" })
	vim.api.nvim_set_hl(0, "CursorColumn", { bold = true, bg = "#1b1b1b" })
	vim.api.nvim_set_hl(0, "MatchParen", { fg = "#ffb86c", bold = true })
	vim.api.nvim_set_hl(0, "TablineFIll", { bold = true, italic = true })

	local lspref_color = "#77ff77"
	vim.api.nvim_set_hl(0, "LspReferenceText", { fg = "#000000", bg = lspref_color, bold = true, underline = true })
	vim.api.nvim_set_hl(0, "LspReferenceRead", { fg = "#000000", bg = lspref_color, bold = true, underline = true })
	vim.api.nvim_set_hl(0, "LspReferenceWrite", { fg = "#000000", bg = lspref_color, bold = true, underline = true })

	vim.api.nvim_set_hl(0, "SymbolUsageRounding", { italic = true })
	vim.api.nvim_set_hl(0, "SymbolUsageContent", { fg = "#6a6a6a", italic = true })
	vim.api.nvim_set_hl(0, "SymbolUsageRef", { fg = "#6f5a5a", italic = true })
	vim.api.nvim_set_hl(0, "SymbolUsageImpl", { fg = "#5a5a6f", italic = true })
	vim.api.nvim_set_hl(0, "Comment", { bg = "none", fg = "#6f7b69" })
	vim.api.nvim_set_hl(0, "LspInlayHint", { fg = "#555555", bold = true, italic = true })

	vim.api.nvim_set_hl(0, "NormalFloat", { bg = "#232323", bold = true, italic = true })
	vim.api.nvim_set_hl(0, "WinBar", { bg = "#232323", bold = true, italic = true })
	vim.api.nvim_set_hl(0, "WinBarNC", { bg = "#232323", bold = true, italic = true })

	vim.api.nvim_set_hl(0, "BlinkCmpMenu", { link = "NormalFloat" })
	vim.api.nvim_set_hl(0, "BlinkCmpDoc", { link = "NormalFloat" })
	vim.api.nvim_set_hl(0, "DiagnosticFloatingError", { link = "NormalFloat" })
	vim.api.nvim_set_hl(0, "DiagnosticFloatingWarn", { link = "NormalFloat" })
	vim.api.nvim_set_hl(0, "DiagnosticFloatingInfo", { link = "NormalFloat" })
	vim.api.nvim_set_hl(0, "DiagnosticFloatingHint", { link = "NormalFloat" })
	vim.api.nvim_set_hl(0, "DiagnosticFloatingOk", { link = "NormalFloat" })

	local buffer_bg_color = "#0a0a0d"
	vim.api.nvim_set_hl(0, "Normal", { bg = buffer_bg_color })
	vim.api.nvim_set_hl(0, "NormalNC", { bg = buffer_bg_color })
	vim.api.nvim_set_hl(0, "EndOfBuffer", { bg = buffer_bg_color })
end

return M
