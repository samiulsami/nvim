---Local plugin specification. Distinct from |vim.pack.Spec|
---@class PluginSpec
---@field src string
---@field version? string|vim.VersionRange
---@field deps? PluginSpec[]
---@field build? fun(path: string)
---@field config? fun()

---@class PackConfig
---@field build_hooks table<string, fun(path: string)>
---@field pending_builds table<string, string>
---@field loaded table<string, boolean>
---@field specs vim.pack.Spec[]
local M = {
	build_hooks = {},
	pending_builds = {},
	loaded = {},
	specs = {},
}

-- NOTE: this only lists pending updates. save the buffer to apply the updates
vim.api.nvim_create_user_command("PackUpdate", function()
	vim.pack.update()
end, { desc = "Update all vim.pack plugins" })

vim.api.nvim_create_user_command("PackList", function()
	vim.pack.update(nil, { offline = true })
end, { desc = "List vim.pack plugins" })

vim.api.nvim_create_user_command("PackRevert", function()
	vim.pack.update(nil, { offline = true, target = "lockfile" })
end, { desc = "Revert vim.pack plugins to lockfile versions" })

vim.api.nvim_create_user_command("PackBuildAll", function()
	for _, spec in ipairs(M.specs) do
		local build = M.build_hooks[spec.src]
		if type(build) == "function" then
			vim.notify("Running build for plugin " .. spec.src, vim.log.levels.INFO)
			pcall(build, spec.src)
		end
	end
end, { desc = "Run build functions of all plugins" })

function M:run_pending_builds()
	for src, path in pairs(self.pending_builds) do
		local build = self.build_hooks[src]
		if type(build) == "function" then
			vim.notify("Running build for plugin " .. src, vim.log.levels.INFO)
			pcall(build, path)
		end
	end

	self.pending_builds = {}
end

vim.api.nvim_create_user_command("PackBuild", function()
	M:run_pending_builds()
end, { desc = "Run pending builds for vim.pack plugins" })

vim.api.nvim_create_autocmd("PackChanged", {
	group = vim.api.nvim_create_augroup("PackBuildHooks", { clear = true }),
	callback = function(ev)
		if ev.data.kind == "delete" then
			return
		end

		local build = M.build_hooks[ev.data.spec.src]
		if not build then
			return
		end

		M.pending_builds[ev.data.spec.src] = ev.data.path
		vim.notify("Plugin " .. ev.data.spec.src .. " has pending build", vim.log.levels.WARN)
	end,
})

---@param spec PluginSpec
function M:load_spec(spec)
	if self.loaded[spec.src] then
		return
	end
	self.loaded[spec.src] = true

	for _, dep in ipairs(spec.deps or {}) do
		self:load_spec(dep)
	end

	if spec.build then
		self.build_hooks[spec.src] = spec.build
	end

	---@type vim.pack.Spec
	local pack_spec = {
		src = spec.src,
		version = spec.version,
		config = spec.config,
	}

	self.specs[#self.specs + 1] = pack_spec
end

---@param path string
function M:load_plugins(path)
	self.build_hooks = {}
	self.pending_builds = {}
	self.loaded = {}
	self.specs = {}

	local plugin_files = vim.fn.glob(path, false, true)
	table.sort(plugin_files)

	local errors = {}

	for _, plugin_file in ipairs(plugin_files) do
		local ok, spec = pcall(dofile, plugin_file)
		if not ok then
			errors[#errors + 1] = "failed to load plugin spec " .. plugin_file .. ": " .. spec
			goto continue
		end

		if type(spec) ~= "table" or type(spec.src) ~= "string" then
			errors[#errors + 1] = "invalid plugin spec in " .. plugin_file
			goto continue
		end

		self:load_spec(spec)
		::continue::
	end

	if #errors > 0 then
		error("error(s) occurred while loading plugin specs:\n" .. table.concat(errors, "\n"))
	end

	vim.pack.add(self.specs, {
		load = true,
		confirm = true,
	})

	---@param spec vim.pack.Spec
	for _, spec in ipairs(self.specs) do
		if spec.config then
			local ok, err = pcall(spec.config)
			if not ok then
				vim.notify("failed to run config for plugin " .. spec.src .. ": " .. err, vim.log.levels.ERROR)
			end
		end
	end
end

return M
