---@type vim.lsp.Config
return {
	cmd = { "gopls", "-remote=auto" },
	root_markers = { "go.mod" },
	filetypes = { "go", "gomod", "gowork", "gotmpl" },
	settings = {
		gopls = {
			completeUnimported = true,
			usePlaceholders = false,
			analyses = {
				unusedparams = true,
				unusedwrite = true,
				deprecated = true,
				fillreturns = true,
			},
			staticcheck = false,
			codelenses = {
				gc_details = false,
				generate = false,
				regenerate_cgo = false,
			},
			hints = {
				assignVariableTypes = false,
				compositeLiteralFields = false,
				compositeLiteralTypes = false,
				constantValues = true,
				functionTypeParameters = true,
				parameterNames = true,
				rangeVariableTypes = false,
			},
		},
	},
}
