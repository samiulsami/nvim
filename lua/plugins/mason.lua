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
				"shellcheck",
				"shfmt",
				"checkmake",
				"json-lsp",
				"jsonlint",
				"helm-ls",
				"yaml-language-server",
				"yamllint",
				"yamlfix",
				"delve",
				"gofumpt",
				"goimports",
				"golangci-lint",
				"google-java-format",
				"checkstyle",
				"staticcheck",
				"clangd",
				"clang-format",
				"cpplint",
				"dockerfile-language-server",
			},
		})
	end,
}
