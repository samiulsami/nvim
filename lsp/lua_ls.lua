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
	on_init = function(client)
		if client.workspace_folders then
			local path = client.workspace_folders[1].name
			if
				path ~= vim.fn.stdpath("config")
				and (vim.uv.fs_stat(path .. "/.luarc.json") or vim.uv.fs_stat(path .. "/.luarc.jsonc"))
			then
				return
			end
		end

		client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {})
	end,
	settings = {
		Lua = {
			hint = { enable = true },
			diagnostics = { disable = { "missing-fields" } },
			completion = { callSnippet = "Disable", keywordSnippet = "Disable" },
			runtime = { version = "LuaJIT" },
			-- Make the server aware of Neovim runtime files
			-- workspace = {
			-- 	checkThirdParty = false,
			-- 	ignoreDir = { "site/pack/packer/start/nvim-treesitter" },
			-- 	maxPreload = 500,
			-- 	preloadFileSize = 100,
			-- 	library = (function()
			-- 		local lib = {}
			-- 		table.insert(lib, vim.env.VIMRUNTIME)
			-- 		for _, p in ipairs(vim.api.nvim_get_runtime_file("lua", true)) do
			-- 			table.insert(lib, p)
			-- 		end
			-- 		table.insert(lib, "${3rd}/luv/library")
			-- 		table.insert(lib, "${3rd}/busted/library")
			-- 		return lib
			-- 	end)(),
			-- },
		},
	},
}
