return {
	"mason-org/mason.nvim",
	dependencies = {
		"WhoIsSethDaniel/mason-tool-installer",
	},
	lazy = false,
	config = function()
		require("mason").setup()
		require("mason-tool-installer").setup({
			ensure_installed = {
				"stylua",
				"lua-language-server",
				"bash-language-server",
				"json-lsp",
				"helm-ls",
				"yaml-language-server",
				"yamllint",
				"yamlfmt",
				"yamlfix",
				"gomodifytags",
				"gopls",
				"gofumpt",
				"clangd",
				"cpplint",
				"dockerfile-language-server",
			},
		})
	end,
}
