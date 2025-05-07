return {
	cmd = { "yaml-language-server", "--stdio" },
	filetypes = { "yaml", "yml", "yaml.docker-compose", "yaml.gitlab" },
	settings = {
		yaml = {
			schemaStore = {
				-- You must disable built-in schemaStore support if you want to use
				-- this plugin and its advanced options like `ignore`.
				enable = false,
				-- Avoid TypeError: Cannot read properties of undefined (reading 'length')
				url = "",
			},
			schemas = require("schemastore").yaml.schemas(),
		},
		redhat = {
			telemetry = {
				enabled = false,
			},
		},
		single_file_support = true,
	},
}
