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
				"jq",
				"json-lsp",
				"jsonlint",
				"helm-ls",
				"yaml-language-server",
				"yamlfix",
				"fixjson",
				"golangci-lint",
				"gofumpt",
				"goimports",
				"clangd",
				"clang-format",
				"cpplint",
				"dockerfile-language-server",
			},
		})
	end,
}
