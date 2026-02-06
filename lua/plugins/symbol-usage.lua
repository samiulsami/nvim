return {
	spec = {
		{ src = "https://github.com/Wansmer/symbol-usage.nvim" },
	},
	config = function()
		local function text_format(symbol)
			local res = {}

			local stacked_functions_content = symbol.stacked_count > 0 and ("+%s"):format(symbol.stacked_count) or ""

			if symbol.references then
				local usage = symbol.references <= 1 and "usage" or "usages"
				local num = symbol.references == 0 and "no" or symbol.references
				table.insert(res, { "  ", "SymbolUsageRef" })
				table.insert(res, { ("%s %s"):format(num, usage), "SymbolUsageContent" })
			end

			if symbol.implementation then
				if #res > 0 then
					table.insert(res, { " ", "NonText" })
				end
				table.insert(res, { "  ", "SymbolUsageImpl" })
				table.insert(res, { symbol.implementation .. " impls", "SymbolUsageContent" })
			end

			if stacked_functions_content ~= "" then
				if #res > 0 then
					table.insert(res, { " ", "NonText" })
				end
				table.insert(res, { " ", "SymbolUsageImpl" })
				table.insert(res, { stacked_functions_content, "SymbolUsageContent" })
			end

			return res
		end

		local SymbolKind = vim.lsp.protocol.SymbolKind
		require("symbol-usage").setup({
			references = { enabled = true, include_declaration = false },
			definition = { enabled = false },
			implementation = { enabled = false },
			vt_priority = 0,
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
			vt_position = "end_of_line",
			request_pending_text = false,

			text_format = text_format,
		})

		local symbol_usage = require("symbol-usage")
		local showing_usages = true

		local toggle_usages = function()
			showing_usages = not showing_usages

			if showing_usages ~= symbol_usage.toggle_globally() then
				symbol_usage.toggle()
			end

			if showing_usages then
				vim.notify("Enabled Symbol Usage Inlay Hint", vim.log.levels.INFO)
				vim.cmd("e")
			else
				vim.notify("Disabled Symbol Usage Inlay Hint", vim.log.levels.INFO)
			end
		end

		vim.keymap.set("n", "<leader>tu", toggle_usages, { desc = "[T]oggle Symbol [U]sages" })
	end,
}
