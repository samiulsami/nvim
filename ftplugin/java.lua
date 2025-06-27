local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
local home_dir = os.getenv("HOME")
local workspace_base_dir = home_dir .. "/.cache/.java_workspaces/"
local eclipse_dir = home_dir .. "/.eclipse_jdtls"
if vim.fn.isdirectory(workspace_base_dir) == 0 then
	vim.fn.mkdir(workspace_base_dir, "p")
end
local java_path = vim.fn.trim(vim.fn.system("which java"))
local workspace_dir = workspace_base_dir .. project_name
local equinox_launcher = vim.fn.glob(eclipse_dir .. "/plugins/org.eclipse.equinox.launcher_*.jar")

local config = {
	-- The command that starts the language server
	-- See: https://github.com/eclipse/eclipse.jdt.ls#running-from-the-command-line
	cmd = {
		java_path,

		"-Declipse.application=org.eclipse.jdt.ls.core.id1",
		"-Dosgi.bundles.defaultStartLevel=4",
		"-Declipse.product=org.eclipse.jdt.ls.core.product",
		"-Dlog.protocol=false",
		"-Dlog.level=ERROR",
		"-Xmx1g",
		"--add-modules=ALL-SYSTEM",
		"--add-opens",
		"java.base/java.util=ALL-UNNAMED",
		"--add-opens",
		"java.base/java.lang=ALL-UNNAMED",

		"-jar",
		equinox_launcher,

		"-configuration",
		eclipse_dir .. "/config_linux/",

		"-data",
		workspace_dir,
	},

	root_dir = vim.fs.root(0, { ".git", "mvnw", "gradlew" }),

	-- Here you can configure eclipse.jdt.ls specific settings
	-- See https://github.com/eclipse/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line#initialize-request
	-- for a list of options
	settings = {

		-- handlers = {
		-- 	["language/status"] = function(_, _) end,
		-- },
		java = {
			references = {
				includeDecompiledSources = true,
			},
			format = {
				enabled = false,
				settings = {
					-- url = vim.fn.stdpath("config") .. "/lang_servers/intellij-java-google-style.xml",
					-- profile = "GoogleStyle",
				},
			},
			eclipse = {
				downloadSources = true,
			},
			maven = {
				downloadSources = true,
			},
			signatureHelp = { enabled = true },
			contentProvider = { preferred = "fernflower" },
			eclipse = {
				downloadSources = true,
			},
			implementationsCodeLens = {
				enabled = true,
			},
			completion = {
				favoriteStaticMembers = {
					"org.hamcrest.MatcherAssert.assertThat",
					"org.hamcrest.Matchers.*",
					"org.hamcrest.CoreMatchers.*",
					"org.junit.jupiter.api.Assertions.*",
					"java.util.Objects.requireNonNull",
					"java.util.Objects.requireNonNullElse",
					"org.mockito.Mockito.*",
				},
				filteredTypes = {
					"com.sun.*",
					"io.micrometer.shaded.*",
					"java.awt.*",
					"jdk.*",
					"sun.*",
				},
				importOrder = {
					"java",
					"javax",
					"com",
					"org",
				},
			},
			sources = {
				organizeImports = {
					starThreshold = 9999,
					staticStarThreshold = 9999,
				},
			},

			codeGeneration = {
				toString = {
					template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}",
					-- flags = {
					-- 	allow_incremental_sync = true,
					-- },
				},
				useBlocks = true,
			},
			-- configuration = {
			--     runtimes = {
			--         {
			--             name = "java-17-openjdk",
			--             path = "/usr/lib/jvm/default-runtime/bin/java"
			--         }
			--     }
			-- }
			-- project = {
			-- 	referencedLibraries = {
			-- 		"**/lib/*.jar",
			-- 	},
			-- },
		},
	},

	-- Language server `initializationOptions`
	-- You need to extend the `bundles` with paths to jar files
	-- if you want to use additional eclipse.jdt.ls plugins.
	--
	-- See https://github.com/mfussenegger/nvim-jdtls#java-debug-installation
	--
	-- If you don't plan on using the debugger or other eclipse.jdt.ls plugins you can remove this
	init_options = {
		bundles = {},
	},
	handlers = {
		["language/status"] = function() end,
		["$/progress"] = function(_, result, ctx)
			result.value.message = "[jdtls] processing..."
			-- result.value.token = ""
			result.value.kind = ""
			vim.lsp.handlers["$/progress"](_, result, ctx)
		end,
		["window/logMessage"] = function(_, result, ctx)
			if result.type == vim.lsp.protocol.MessageType.Error then
				vim.lsp.handlers["window/logMessage"](_, result, ctx)
			end
		end,
		["window/showMessage"] = function(_, result, ctx)
			if result.type == vim.lsp.protocol.MessageType.Error then
				vim.lsp.handlers["window/showMessage"](_, result, ctx)
			end
		end,
	},
}

require("jdtls").start_or_attach(config)
