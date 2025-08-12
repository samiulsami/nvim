return {
	cmd = { "yaml-language-server", "--stdio" },
	filetypes = { "yaml", "yml", "yaml.docker-compose", "yaml.gitlab" },
	settings = {
		yaml = {
			schemaStore = {
				enable = true,
			},
			schemas = vim.tbl_extend("force", {}, {
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
