return {
	cmd = { "helm_ls", "serve" },
	capabilities = {
		workspace = {
			didChangeWatchedFiles = {
				dynamicRegistration = true,
			},
		},
	},
	filetypes = { "helm", "yaml", "json" },
	root_markers = { "Chart.yaml" },
	settings = {
		["helm-ls"] = {
			logLevel = "info",
			valuesFiles = {
				mainValuesFile = "values.yaml",
				lintOverlayValuesFile = "values.lint.yaml",
				additionalValuesFilesGlobPattern = "values*.yaml",
			},
			yamlls = {
				enabled = true,
				enabledForFilesGlob = "*.{yaml,yml}",
				diagnosticsLimit = 50,
				showDiagnosticsDirectly = true,
				path = "yaml-language-server",
				config = {
					schemas = {
						kubernetes = "templates/**",
					},
					completion = true,
					hover = true,
					-- any other config from https://github.com/redhat-developer/yaml-language-server#language-server-settings
				},
			},
		},
	},
}
