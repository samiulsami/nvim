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
				"yamllint",
				"yamlfix",
				"fixjson",
				"gofumpt",
				"goimports",
				"golangci-lint",
				"clangd",
				"clang-format",
				"cpplint",
				"dockerfile-language-server",
			},
		})

		vim.keymap.set("n", "<leader>M", "<Cmd>Mason<CR>", { noremap = true, silent = true })
	end,
}
