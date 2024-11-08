return {
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
					-- SymbolKind.Field,
					-- SymbolKind.Variable,
					-- SymbolKind.Object,
				},
			})
		end,
	},
	{
		"VidocqH/lsp-lens.nvim",
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
		end,
	},
}
