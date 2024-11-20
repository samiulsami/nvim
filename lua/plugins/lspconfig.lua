-- Modified lspconfig from kickstart.nvim
return {
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			{ "williamboman/mason.nvim", config = true }, -- NOTE: Must be loaded before dependants
			"williamboman/mason-lspconfig.nvim",
			"WhoIsSethDaniel/mason-tool-installer.nvim",
			{
				"kevinhwang91/nvim-ufo",
				dependencies = {
					"kevinhwang91/promise-async",
				},
				config = function()
					vim.keymap.set("n", "zR", require("ufo").openAllFolds)
					vim.keymap.set("n", "zM", require("ufo").closeAllFolds)
				end,
			},
			{
				"antosha417/nvim-lsp-file-operations",
				dependencies = {
					"nvim-lua/plenary.nvim",
					"nvim-neo-tree/neo-tree.nvim",
				},
				config = function()
					require("lsp-file-operations").setup()
				end,
			},
			{ "j-hui/fidget.nvim", opts = {} },
			"hrsh7th/cmp-nvim-lsp",
		},
		config = function()
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
				callback = function(event)
					local map = function(keys, func, desc, mode)
						mode = mode or "n"
						vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
					end
					map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
					map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction", { "n", "x" })
					map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
				end,
			})

			local capabilities = vim.lsp.protocol.make_client_capabilities()
			capabilities = vim.tbl_deep_extend(
				"force",
				capabilities,
				require("cmp_nvim_lsp").default_capabilities(),
				require("lsp-file-operations").default_capabilities()
			)
			capabilities.textDocument.foldingRange = {
				dynamicRegistration = false,
				lineFoldingOnly = true,
			}
			local servers = require("data.language_servers")

			require("mason").setup()

			local ensure_installed = vim.tbl_keys(servers or {})
			vim.list_extend(ensure_installed, require("data.ensure_installed_mason"))
			require("mason-tool-installer").setup({ ensure_installed = ensure_installed })
			require("mason-lspconfig").setup({
				handlers = {
					function(server_name)
						local server = servers[server_name] or {}
						server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
						require("lspconfig")[server_name].setup(server)
					end,
				},
			})

			require("ufo").setup()

			vim.keymap.set(
				"n",
				"<leader>RL",
				":LspRestart<CR>",
				{ noremap = true, silent = true, desc = "[R]efresh [L]sp" }
			)
		end,
	},
}
