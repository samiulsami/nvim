---@brief
---
--- https://github.com/EmmyLuaLs/emmylua-analyzer-rust
---
--- Emmylua Analyzer Rust. Language Server for Lua.
---
--- `emmylua_ls` can be installed using `cargo` by following the instructions[here]
--- (https://github.com/EmmyLuaLs/emmylua-analyzer-rust?tab=readme-ov-file#install).
---
--- The default `cmd` assumes that the `emmylua_ls` binary can be found in `$PATH`.
--- It might require you to provide cargo binaries installation path in it.

---@type vim.lsp.Config
return {
	cmd = { "emmylua_ls" },
	filetypes = { "lua" },
	root_markers = {
		".luarc.json",
		".emmyrc.json",
		".luacheckrc",
		".git",
	},
	workspace_required = false,
	settings = {
		Lua = {
			hint = { enable = true },
			diagnostics = { disable = { "missing-fields" } },
			completion = { callSnippet = "Disable", keywordSnippet = "Disable" },
			runtime = { version = "LuaJIT" },
			-- Make the server aware of Neovim runtime files
			workspace = {
				checkThirdParty = false,
				ignoreDir = { "site/pack/packer/start/nvim-treesitter" },
				maxPreload = 500,
				preloadFileSize = 100,
				library = (function()
					local lib = {}
					table.insert(lib, vim.env.VIMRUNTIME)
					for _, p in ipairs(vim.api.nvim_get_runtime_file("lua", true)) do
						table.insert(lib, p)
					end
					table.insert(lib, "${3rd}/luv/library")
					table.insert(lib, "${3rd}/busted/library")
					return lib
				end)(),
			},
		},
	},
}
