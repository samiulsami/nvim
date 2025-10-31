-- Bootstrap mini.nvim
local path_package = vim.fn.stdpath('data') .. '/site'
local mini_path = path_package .. '/pack/deps/start/mini.nvim'
if not vim.loop.fs_stat(mini_path) then
	vim.cmd('echo "Installing mini.nvim" | redraw')
	vim.fn.system({
		'git', 'clone', '--filter=blob:none',
		'https://github.com/nvim-mini/mini.nvim', mini_path
	})
	vim.cmd('packadd mini.nvim | helptags ALL')
	vim.cmd('echo "Installed mini.nvim" | redraw')
end

require('mini.deps').setup({ path = { package = path_package } })

-- Load all plugins from lua/plugins/*.lua
local plugins_dir = vim.fn.stdpath('config') .. '/lua/plugins'
local plugin_files = vim.fn.globpath(plugins_dir, '*.lua', false, true)

for _, file in ipairs(plugin_files) do
	local name = file:match('([^/]+)%.lua$')
	if name then
		local ok, spec = pcall(require, 'plugins.' .. name)
		if ok and spec then
			-- Normalize to array
			local specs = spec
			if type(spec) == 'table' and spec[1] == nil then
				specs = { spec }
			end
			
			for _, s in ipairs(specs) do
				-- TODO: Convert lazy.nvim spec to mini.deps
				-- s[1] or s.source -> source for MiniDeps.add()
				-- s.dependencies -> depends for MiniDeps.add()
				-- s.config -> call after MiniDeps.add()
				-- s.lazy/ft/cmd/event -> setup autocmds to call MiniDeps.add() on demand
			end
		end
	end
end
