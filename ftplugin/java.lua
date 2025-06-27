local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
local workspace_dir = "/home/sami/java_workspace/" .. project_name
local homeDir = os.getenv("HOME")

local config = {
	-- The command that starts the language server
	-- See: https://github.com/eclipse/eclipse.jdt.ls#running-from-the-command-line
	cmd = {
		-- 💀
		"/usr/lib/jvm/jdk/bin/java",

		"-Declipse.application=org.eclipse.jdt.ls.core.id1",
		"-Dosgi.bundles.defaultStartLevel=4",
		"-Declipse.product=org.eclipse.jdt.ls.core.product",
		"-Dlog.protocol=true",
		"-Dlog.level=ALL",
		"-Xmx1g",
		"--add-modules=ALL-SYSTEM",
		"--add-opens",
		"java.base/java.util=ALL-UNNAMED",
		"--add-opens",
		"java.base/java.lang=ALL-UNNAMED",

		-- 💀
		"-jar",
		homeDir .. "/eclipse_jdtls/plugins/org.eclipse.equinox.launcher_1.7.0.v20250424-1814.jar",

		-- 💀
		"-configuration",
		homeDir .. "/eclipse_jdtls/config_linux/",

		-- 💀
		-- See `data directory configuration` section in the README
		"-data",
		workspace_dir,
	},

	root_dir = vim.fs.root(0, { ".git", "mvnw", "gradlew" }),

	-- Here you can configure eclipse.jdt.ls specific settings
	-- See https://github.com/eclipse/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line#initialize-request
	-- for a list of options
	settings = {
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
}
require("jdtls").start_or_attach(config)
