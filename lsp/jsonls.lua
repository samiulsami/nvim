-- npm i -g vscode-langservers-extracted
-- npm install -g fixjson
return {
	cmd = { "vscode-json-language-server", "--stdio" },
	filetypes = { "json", "jsonc" },
	init_options = { provide_formatters = true },
	root_markers = { ".git" },
	settings = {
		json = {
			validate = { enable = true },
		},
	},
}
