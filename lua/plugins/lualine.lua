return {
	"nvim-lualine/lualine.nvim",
	dependencies = {
		"folke/tokyonight.nvim",
	},
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

		local function search_result()
			if not vim.g.lualine_show_search_index then
				return ""
			end
			local ok, result = pcall(vim.fn.searchcount, { maxcount = 9999, timeout = 500 })
			if not ok or not result or result.total == 0 then
				return ""
			end
			return string.format("[%d/%d]", result.current, result.total) or ""
		end

		vim.api.nvim_create_autocmd("CmdlineEnter", {
			pattern = "/,?",
			callback = function()
				vim.g.lualine_show_search_index = true
			end,
		})

		for _, key in ipairs({ "n", "N", "*", "#", "g*", "g#" }) do
			vim.keymap.set("n", key, function()
				vim.g.lualine_show_search_index = true
				require("lualine").refresh()
				return key
			end, { expr = true, desc = "Show Search Count" })
		end

		local function mode()
			local str = vim.api.nvim_get_mode()
			return str.mode:upper()
		end

		local function macro_recording()
			local recording_macro = vim.fn.reg_recording()
			if recording_macro ~= "" then
				return "@" .. recording_macro
			end
			return ""
		end

		vim.api.nvim_create_autocmd({ "RecordingEnter", "RecordingLeave" }, {
			callback = function()
				require("lualine").refresh()
			end,
		})

		local notification_util = require("utils.notifications")
		local notification_color = "#555555"
		local function notifications()
			local unseen_notifications, preview, max_level = notification_util:get_unseen_notification_stats()
			if unseen_notifications <= 0 then
				return ""
			end
			if max_level <= vim.log.levels.INFO then
				notification_color = "#66bb77"
			elseif max_level <= vim.log.levels.WARN then
				notification_color = "#ccaa66"
			else
				notification_color = "#ff4444"
			end

			if preview == "" then
				preview = "[Empty Message]"
			end

			return string.format("[%d] %s", unseen_notifications, preview)
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
				component_separators = { left = "", right = "" },
			},

			sections = {
				lualine_a = {
					mode,
				},
				lualine_b = {
					{
						macro_recording,
						color = { bg = "#ff2211", fg = "#ffffff" },
					},
					"branch",
					"diff",
				},
				lualine_c = {
					luaLineShortenedPath,
					"diagnostics",
					search_result,
				},
				lualine_x = {
					{
						notifications,
						color = function()
							return {
								bg = notification_color,
								fg = "#000000",
							}
						end,
					},
				},
				lualine_y = { "progress" },
				lualine_z = { "location" },
			},
			inactive_sections = {
				lualine_c = {
					luaLineShortenedPath,
				},
				lualine_x = {
					{
						color = function()
							return {
								bg = notification_color,
								fg = "#000000",
							}
						end,
					},
				},
			},
		})
	end,
}
