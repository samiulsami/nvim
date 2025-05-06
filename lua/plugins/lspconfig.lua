-- Modified lspconfig from kickstart.nvim
return {
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			{ "williamboman/mason.nvim", config = true },
			{ "williamboman/mason-lspconfig.nvim" },
			{ "WhoIsSethDaniel/mason-tool-installer.nvim" },
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
			{ "hrsh7th/cmp-nvim-lsp" },
			{ "b0o/schemastore.nvim" },
			{ "j-hui/fidget.nvim", opts = {} },
		},
		config = function()
			local capabilities = vim.lsp.protocol.make_client_capabilities()
			capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())
			capabilities.textDocument.foldingRange = {
				dynamicRegistration = false,
				lineFoldingOnly = true,
			}
			local servers = require("data.language_servers")

			require("mason").setup()

			local ensure_installed = vim.tbl_keys(servers or {})
			vim.list_extend(ensure_installed, require("data.ensure_installed_mason"))
			require("mason-tool-installer").setup({
				ensure_installed = ensure_installed,
				run_on_start = false,
			})
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

			vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { desc = "LSP [R]e[n]ame" })
			vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "LSP [C]ode [A]ction" })
			vim.keymap.set(
				"n",
				"<leader>RL",
				":LspRestart<CR>",
				{ noremap = true, silent = true, desc = "[R]efresh [L]sp" }
			)

			vim.lsp.inlay_hint.enable(false)
			vim.keymap.set("n", "<leader>th", function()
				local hinstsEnabled = vim.lsp.inlay_hint.is_enabled()
				vim.lsp.inlay_hint.enable(not hinstsEnabled)
				if not hinstsEnabled then
					vim.notify("Inlay hints enabled")
				else
					vim.notify("Inlay hints disabled")
				end
			end, { desc = "[T]oggle Inlay [H]ints" })

			vim.api.nvim_set_hl(0, "LspReferenceText", { bold = true, underline = true })
			vim.api.nvim_set_hl(0, "LspReferenceRead", { bold = true, underline = true })
			vim.api.nvim_set_hl(0, "LspReferenceWrite", { bold = true, underline = true })
		end,
	},
}
