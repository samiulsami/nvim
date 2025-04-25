return {
	clangd = { -- Add clangd here
		cmd = { "clangd" },
		filetypes = { "c", "cpp", "objc", "objcpp" }, -- Supported filetypes
		root_dir = require("lspconfig.util").root_pattern("compile_commands.json", "Makefile", ".git"), -- Determine the root directory
		settings = {
			clangd = {
				-- Add any specific clangd settings here if needed
			},
		},
	},

	gopls = {
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
	},

	lua_ls = {
		settings = {
			Lua = {
				completion = {
					callSnippet = "Replace",
				},
				-- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
				diagnostics = { disable = { "missing-fields" } },
			},
		},
	},

	yamlls = {
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
	},

	jsonls = {
		settings = {
			json = {
				schemas = require("schemastore").json.schemas(),
				validate = { enable = true },
			},
		},
	},

	bashls = {
		filetypes = { "sh", "bash", "zsh", "make" },
		settings = {
			bashIde = {
				globPattern = "*@(.sh|.inc|.bash|.command|Makefile)",
			},
		},
	},
}
