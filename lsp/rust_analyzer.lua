---@type vim.lsp.Config
return {
	cmd = { "rust-analyzer" },
	filetypes = { "rust" },
	root_markers = { "Cargo.toml", "rust-project.json", ".git" },
	settings = {
		["rust-analyzer"] = {
			checkOnSave = false,
			cargo = {
				targetDir = true,
			},
			completion = {
				callable = {
					snippets = "none",
				},
			},
			diagnostics = {
				enable = false,
			},
		},
	},
}
