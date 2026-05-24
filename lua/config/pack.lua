---@class PackSpec
---@field src string
---@field version? string|vim.VersionRange
---@field deps? PackSpec[]
---@field build? fun(path: string)
---@field config? fun()

---@class PackConfig
---@field build_hooks table<string, fun(path: string)>
---@field pending_builds table<string, string>
---@field loaded table<string, boolean>
---@field specs vim.pack.Spec[]
---@field configs fun()[]
local M = {
	build_hooks = {},
	pending_builds = {},
	loaded = {},
	specs = {},
	configs = {},
}

vim.api.nvim_create_user_command("PackUpdate", function()
	vim.pack.update()
end, { desc = "Update all vim.pack plugins" })

vim.api.nvim_create_user_command("PackList", function()
	vim.pack.update(nil, { offline = true })
end, { desc = "List vim.pack plugins" })

vim.api.nvim_create_user_command("PackSync", function()
	vim.pack.update(nil, { target = "lockfile" })
end, { desc = "Sync vim.pack plugins to lockfile" })

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
	end,
})

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
	}

	self.specs[#self.specs + 1] = pack_spec
	self.configs[#self.configs + 1] = spec.config
end

function M:run_pending_builds()
	for src, path in pairs(self.pending_builds) do
		local build = self.build_hooks[src]
		if build then
			build(path)
		end
	end

	self.pending_builds = {}
end

---@param path string
function M:load_plugins(path)
        self.build_hooks = {}
        self.pending_builds = {}
        self.loaded = {}
        self.specs = {}
        self.configs = {}

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
                confirm = false,
        })
        self:run_pending_builds()

        for _, config in ipairs(self.configs) do
                if config then
                        config()
                end
        end
end

return M
