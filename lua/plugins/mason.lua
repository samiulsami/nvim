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
				"codespell",
				"json-lsp",
				"helm-ls",
				"yaml-language-server",
				"yamllint",
				"yamlfmt",
				"yamlfix",
				"gopls",
				"delve",
				"gofumpt",
				"goimports",
				"golangci-lint",
				"golines",
				"clangd",
				"clang-format",
				"cpplint",
				"dockerfile-language-server",
			},
		})
	end,
}
