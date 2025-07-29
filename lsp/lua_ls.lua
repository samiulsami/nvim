-- https://github.com/LuaLS/lua-language-server/releases
return {
	cmd = { "lua-language-server" },
	filetypes = { "lua" },
	root_markers = {
		".git",
		"lua",
		".luarc.json",
		".luarc.jsonc",
		".luacheckrc",
		".stylua.toml",
		"stylua.toml",
		"selene.toml",
		"selene.yml",
	},
	settings = {
		Lua = {
			hint = { enable = true },
			diagnostics = {
				disable = { "missing-fields" },
			},
			runtime = { version = "LuaJIT" },
			completion = {
				callSnippet = "Disable",
				keywordSnippet = "Disable",
			},
		},
	},
}
