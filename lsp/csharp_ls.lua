---@brief
---
--- https://github.com/razzmatazz/csharp-language-server
---
--- Language Server for C#.
---
--- csharp-ls requires the [dotnet-sdk](https://dotnet.microsoft.com/download) to be installed.
---
--- The preferred way to install csharp-ls is with `dotnet tool install --global csharp-ls`.
---

local search_ancestors = function(startpath, func)
	vim.validate("func", func, "function")
	if func(startpath) then
		return startpath
	end
	local guard = 100
	for path in vim.fs.parents(startpath) do
		-- Prevent infinite recursion if our algorithm breaks
		guard = guard - 1
		if guard == 0 then
			return
		end

		if func(path) then
			return path
		end
	end
end

local root_pattern = function(...)
	local patterns = vim.iter(...):flatten(math.huge):totable()
	return function(startpath)
		startpath = vim.fn.substitute(startpath, "zipfile://\\(.\\{-}\\)::[^\\\\].*$", "\\1", "")
		startpath = vim.fn.substitute(startpath, "tarfile:\\(.\\{-}\\)::.*$", "\\1", "")
		for _, pattern in ipairs(patterns) do
			local match = search_ancestors(startpath, function(path)
				for _, p in
					ipairs(vim.fn.glob(table.concat({ path:gsub("([%[%]%?%*])", "\\%1"), pattern }, "/"), true, true))
				do
					if vim.uv.fs_stat(p) then
						return path
					end
				end
			end)

			if match ~= nil then
				local real = vim.uv.fs_realpath(match)
				return real or match -- fallback to original if realpath fails
			end
		end
	end
end

---@type vim.lsp.Config
return {
	cmd = function(dispatchers, config)
		return vim.lsp.rpc.start({ "csharp-ls" }, dispatchers, {
			-- csharp-ls attempt to locate sln, slnx or csproj files from cwd, so set cwd to root directory.
			-- If cmd_cwd is provided, use it instead.
			cwd = config.cmd_cwd or config.root_dir,
			env = config.cmd_env,
			detached = config.detached,
		})
	end,
	root_markers = { ".git" },
	-- root_dir = function(bufnr, on_dir)
	-- 	local fname = vim.api.nvim_buf_get_name(bufnr)
	-- 	on_dir(root_pattern("*.sln")(fname) or root_pattern("*.slnx")(fname) or root_pattern("*.csproj")(fname))
	-- end,
	filetypes = { "cs" },
	init_options = {
		AutomaticWorkspaceInit = true,
	},
}
