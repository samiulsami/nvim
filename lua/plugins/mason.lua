return {
	spec = {
		{ src = "https://github.com/WhoIsSethDaniel/mason-tool-installer" },
		{ src = "https://github.com/mason-org/mason.nvim" },
	},
	config = function()
		local ensure_installed = {
			"stylua",
			"lua-language-server",
			"bash-language-server",
			"shellcheck",
			"shfmt",
			"checkmake",
			"terraform",
			"terraform-ls",
			"tflint",
			"jq",
			"tree-sitter-cli",
			"json-lsp",
			"jsonlint",
			"helm-ls",
			"yaml-language-server",
			"yamlfix",
			"fixjson",
			"gopls",
			"golangci-lint",
			"gofumpt",
			"goimports",
			"clangd",
			"clang-format",
			"cpplint",
			"dockerfile-language-server",
		}

		-- for mason package names that don't match their executable names
		local executable_mappings = {}
		executable_mappings["tree-sitter-cli"] = "tree-sitter"

		local to_install = {}
		for _, app in ipairs(ensure_installed) do
			local executable = executable_mappings[app] or app
			local path = vim.fn.trim(vim.fn.system("which " .. executable))
			if path == "" or vim.v.shell_error ~= 0 then
				table.insert(to_install, app)
			end
		end

		require("mason").setup()
		require("mason-tool-installer").setup({
			ensure_installed = to_install,
			integrations = {
				["mason-lspconfig"] = false,
				["mason-null-ls"] = false,
				["mason-nvim-dap"] = false,
			},
		})
	end,
}
