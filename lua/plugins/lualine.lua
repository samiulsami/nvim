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

		local custom_lualine_theme = require("lualine.themes.horizon")
		custom_lualine_theme.normal.a.fg = "#1d1d1d"
		custom_lualine_theme.normal.a.bg = "#0099aa"

		custom_lualine_theme.insert.a.fg = "#1d1d1d"
		custom_lualine_theme.insert.a.bg = "#dd11dd"

		custom_lualine_theme.visual.a.fg = "#1d1d1d"
		custom_lualine_theme.visual.a.bg = "#dd0000"

		custom_lualine_theme.replace.a.fg = "#1d1d1d"
		custom_lualine_theme.replace.a.bg = "#dddd55"

		custom_lualine_theme.command.a.fg = "#1d1d1d"
		custom_lualine_theme.command.a.bg = "#6fdd6f"

		custom_lualine_theme.normal.b.fg = "#ffffff"
		custom_lualine_theme.replace.b.fg = "#ffffff"
		custom_lualine_theme.insert.b.fg = "#ffffff"
		custom_lualine_theme.visual.b.fg = "#ffffff"
		custom_lualine_theme.command.b.fg = "#ffffff"

		custom_lualine_theme.normal.b.bg = "#110a11"
		custom_lualine_theme.replace.b.bg = "#110a11"
		custom_lualine_theme.insert.b.bg = "#110a11"
		custom_lualine_theme.visual.b.bg = "#110a11"
		custom_lualine_theme.command.b.bg = "#110a11"

		custom_lualine_theme.normal.c.fg = "#dddddd"
		custom_lualine_theme.replace.c.fg = "#dddddd"
		custom_lualine_theme.insert.c.fg = "#dddddd"
		custom_lualine_theme.visual.c.fg = "#dddddd"
		custom_lualine_theme.command.c.fg = "#dddddd"

		custom_lualine_theme.normal.c.bg = "#0a0a0a"
		custom_lualine_theme.replace.c.bg = "#0a0a0a"
		custom_lualine_theme.insert.c.bg = "#0a0a0a"
		custom_lualine_theme.visual.c.bg = "#0a0a0a"
		custom_lualine_theme.command.c.bg = "#0a0a0a"

		custom_lualine_theme.inactive.c.fg = "#444444"
		custom_lualine_theme.inactive.c.bg = "#000000"

		require("lualine").setup({
			options = {
				theme = custom_lualine_theme,
				section_separators = "|",
				component_separators = "|",
				refresh = {
					statusline = 100,
					tabline = 1000,
					winbar = 1000,
				},
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
			inactive_sections = {},
		})
	end,
}
