return {

	{
		"Wansmer/symbol-usage.nvim",
		event = "BufReadPre",
		config = function()
			local SymbolKind = vim.lsp.protocol.SymbolKind
			require("symbol-usage").setup({
				kinds = {
					SymbolKind.Function,
					SymbolKind.Method,
					SymbolKind.Interface,
					SymbolKind.Class,
					SymbolKind.Struct,
					SymbolKind.Enum,
					SymbolKind.Constant,
					SymbolKind.Field,
					SymbolKind.Variable,
					SymbolKind.Object,
				},
			})

			local showing_usages = true
			local toggle_usages = function()
				showing_usages = not showing_usages

				if showing_usages ~= require("symbol-usage").toggle_globally() then
					require("symbol-usage").toggle()
				end

				if showing_usages then
					vim.notify("Enabled Symbol Usage Inlay Hint", vim.log.levels.INFO)
					vim.cmd("bufdo e")
				else
					vim.notify("Disabled Symbol Usage Inlay Hint", vim.log.levels.INFO)
				end
			end

			toggle_usages()

			vim.keymap.set("n", "<leader>tu", toggle_usages, { desc = "[T]oggle Symbol [U]sages" })
		end,
	},
}
