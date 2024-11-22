return {

	{
		"VidocqH/lsp-lens.nvim",
		dependencies = {
			{
				"Wansmer/symbol-usage.nvim",
				event = "BufReadPre", -- need run before LspAttach if you use nvim 0.9. On 0.10 use 'LspAttach'
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
				end,
			},
		},
		config = function()
			local SymbolKind = vim.lsp.protocol.SymbolKind
			require("lsp-lens").setup({
				enable = true,
				include_declaration = false,
				sections = {
					definition = false,
					implements = true,
					references = false,
					git_authors = false,
				},
				ignore_filetype = {
					"prisma",
				},
				-- Target Symbol Kinds to show lens information
				target_symbol_kinds = {
					SymbolKind.Interface,
					SymbolKind.Class,
					SymbolKind.Struct,
				},
				-- Symbol Kinds that may have target symbol kinds as children
				wrapper_symbol_kinds = {
					SymbolKind.Interface,
					SymbolKind.Class,
					SymbolKind.Struct,
				},
			})

			local showing_usages = true
			local toggle_usages = function()
				showing_usages = not showing_usages

				if showing_usages then
					vim.cmd("LspLensOn")
				else
					vim.cmd("LspLensOff")
				end

				if showing_usages ~= require("symbol-usage").toggle_globally() then
					require("symbol-usage").toggle()
				end

				if showing_usages then
					vim.notify("Enabled Symbol Usage Inlay Hint", vim.log.levels.INFO)
				else
					vim.notify("Disabled Symbol Usage Inlay Hint", vim.log.levels.INFO)
				end
			end

			vim.keymap.set("n", "<leader>tu", toggle_usages, { desc = "[T]oggle Symbol [U]sages" })
		end,
	},
}
