return {
	clangd = { -- Add clangd here
		cmd = { "clangd" },
		filetypes = { "c", "cpp", "objc", "objcpp" }, -- Supported file types
		root_dir = require("lspconfig.util").root_pattern("compile_commands.json", "Makefile", ".git"), -- Determine the root directory
		settings = {
			clangd = {
				-- Add any specific clangd settings here if needed
			},
		},
	},

	gopls = {
		cmd = { "gopls" },
		filetypes = { "go", "gomod", "gowork", "gotmpl" },
		root_dir = function(fname)
			-- see: https://github.com/neovim/nvim-lspconfig/issues/804
			if not mod_cache then
				local result = require("lspconfig.async").run_command({ "go", "env", "GOMODCACHE" })
				if result and result[1] then
					mod_cache = vim.trim(result[1])
				else
					mod_cache = vim.fn.system("go env GOMODCACHE")
				end
			end
			if mod_cache and fname:sub(1, #mod_cache) == mod_cache then
				local clients = require("lspconfig.util").get_lsp_clients({ name = "gopls" })
				if #clients > 0 then
					return clients[#clients].config.root_dir
				end
			end
			return require("lspconfig.util").root_pattern("go.work", "go.mod", ".git")(fname)
		end,

		settings = {
			gopls = {
				completeUnimported = true,
				usePlaceholders = false,
				analyses = {
					unusedparams = true,
					deprecated = true,
					fillreturns = true,
				},
				staticcheck = true,
				gofumpt = true,
			},
		},
	},
	-- pyright = {},
	-- rust_analyzer = {},
	--
	-- Some languages (like typescript) have entire language plugins that can be useful:
	--    https://github.com/pmizio/typescript-tools.nvim
	--
	-- But for many setups, the LSP (`ts_ls`) will work just fine
	-- ts_ls = {},
	--

	lua_ls = {
		-- cmd = {...},
		-- filetypes = { ...},
		-- capabilities = {},
		settings = {
			Lua = {
				completion = {
					callSnippet = "Replace",
				},
				-- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
				-- diagnostics = { disable = { 'missing-fields' } },
			},
		},
	},
}
