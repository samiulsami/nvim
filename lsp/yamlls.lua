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
			schemas = vim.tbl_extend("force", require("schemastore").yaml.schemas(), {
				["https://raw.githubusercontent.com/yannh/kubernetes-json-schema/refs/heads/master/v1.32.1-standalone-strict/all.json"] = "/*.k8s.yaml",
			}),
		},
		redhat = {
			telemetry = {
				enabled = false,
			},
		},
		single_file_support = true,
	},
}
