-- go install golang.org/x/tools/gopls@latest
-- go install mvdan.cc/gofumpt@latest
-- go install golang.org/x/tools/cmd/goimports@latest
return {
	cmd = { "gopls", "-remote=auto" },
	filetypes = { "go", "gomod", "gowork", "gotmpl" },
	settings = {
		gopls = {
			workspaceSymbolScope = "all",
			completeUnimported = true,
			usePlaceholders = false,
			analyses = {
				unusedparams = true,
				deprecated = true,
				fillreturns = true,
			},
			codelenses = {
				gc_details = true,
				generate = true,
				regenerate_cgo = true,
				tidy = true,
			},
			hints = {
				assignVariableTypes = false,
				compositeLiteralFields = true,
				compositeLiteralTypes = true,
				constantValues = true,
				functionTypeParameters = true,
				parameterNames = true,
				rangeVariableTypes = true,
			},
			staticcheck = true,
			gofumpt = true,
			semanticTokens = true,
		},
	},
}
