return {
	"nvim-lualine/lualine.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		local function trimString(s)
			return s:match("^%s*(.-)%s*$")
		end

		local function luaLineShortenedPath()
			local path = vim.fn.expand("%:p")
			local homePattern = "^/*" .. vim.fn.expand("~")
			local prefix = ""

			local colonPos = path:find(":")
			if colonPos then
				prefix = "[" .. path:sub(1, colonPos - 1):upper() .. "]:"
				path = path:sub(colonPos + 1)
			end

			if vim.fn.match(path, homePattern) ~= -1 then
				path = vim.fn.substitute(path, homePattern, "~", "")
			end

			local components = {}
			for _, component in ipairs(vim.split(path, "/")) do
				component = trimString(component)
				if #component > 0 then
					table.insert(components, component)
				end
			end

			for i, component in ipairs(components) do
				if i >= #components - 1 then
					break
				end

				if component:sub(1, 1) == "." and #component > 1 then
					components[i] = component:sub(1, 2)
				else
					components[i] = component:sub(1, 1)
				end
			end

			if vim.bo.modified and #components > 0 then
				components[#components] = components[#components] .. " ●"
			end

			return prefix .. table.concat(components, "/")
		end

		local function mode()
			local str = vim.api.nvim_get_mode()
			return str.mode:upper()
		end

		local custom_lualine_theme = require("lualine.themes.tokyonight")
		custom_lualine_theme.normal.b.bg = "#110a22"
		custom_lualine_theme.replace.b.bg = "#110a22"
		custom_lualine_theme.insert.b.bg = "#110a22"
		custom_lualine_theme.visual.b.bg = "#110a22"
		custom_lualine_theme.command.b.bg = "#110a22"
		custom_lualine_theme.terminal.b.bg = "#110a22"

		custom_lualine_theme.normal.c.bg = "#0a0a0a"

		custom_lualine_theme.inactive.c.fg = "#555555"
		custom_lualine_theme.inactive.c.bg = "#000000"

		require("lualine").setup({
			options = {
				theme = custom_lualine_theme,
			},

			sections = {
				lualine_a = { mode },
				lualine_b = { "branch", "diff" },
				lualine_c = {
					luaLineShortenedPath,
					"diagnostics",
				},
				lualine_x = { "encoding", "fileformat", "filetype" },
				lualine_y = { "progress" },
				lualine_z = { "location" },
			},
			inactive_sections = {
				lualine_c = {
					luaLineShortenedPath,
				},
			},
		})
	end,
}
