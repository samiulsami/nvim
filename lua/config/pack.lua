-- vim.pack plugin loader
-- Each plugin file in lua/plugins/ exports:
--   spec  = { src = "..." } or list of specs (all plugins, including deps)
--   config = function() ... end   (optional)
--   build  = string or function   (optional, runs on install/update via PackChanged)

local plugins_dir = vim.fn.stdpath("config") .. "/lua/plugins"

local specs = {}
local configs = {}
local builds = {}

local files = vim.fn.glob(plugins_dir .. "/*.lua", false, true)
for _, file in ipairs(files) do
	local module_name = "plugins." .. vim.fn.fnamemodify(file, ":t:r")
	local ok, plugin = pcall(require, module_name)
	if ok and plugin and plugin.spec then
		local spec_list = plugin.spec[1] and type(plugin.spec[1]) == "table" and plugin.spec or { plugin.spec }
		for _, s in ipairs(spec_list) do
			table.insert(specs, s)
		end

		if plugin.build then
			for _, s in ipairs(spec_list) do
				local name = s.name or s.src:match("([^/]+)$")
				builds[name] = plugin.build
			end
		end

		if plugin.config then
			table.insert(configs, { fn = plugin.config, module = module_name })
		end
	end
end

-- Register build hooks before add() so install triggers them
vim.api.nvim_create_autocmd("PackChanged", {
	callback = function(ev)
		local name = ev.data.spec.name
		local kind = ev.data.kind
		if (kind == "install" or kind == "update") and builds[name] then
			local build = builds[name]
			if type(build) == "string" then
				if build:sub(1, 1) == ":" then
					vim.cmd(build:sub(2))
				else
					vim.system({ "sh", "-c", build }, { cwd = ev.data.path }):wait()
				end
			elseif type(build) == "function" then
				build(ev.data)
			end
		end
	end,
})

vim.pack.add(specs)

for _, entry in ipairs(configs) do
	local ok, err = pcall(entry.fn)
	if not ok then
		vim.notify("Config error (" .. entry.module .. "): " .. tostring(err), vim.log.levels.WARN)
	end
end
