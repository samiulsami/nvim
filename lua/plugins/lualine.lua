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
			local total_length = 0
			for _, component in ipairs(vim.split(path, "/")) do
				component = trimString(component)
				total_length = total_length + #component
				if #component > 0 then
					table.insert(components, component)
				end
			end

			local path_prefix_length_soft_limit = 0
			for i, component in ipairs(components) do
				if total_length <= path_prefix_length_soft_limit or i >= #components - 1 then
					break
				end

				total_length = total_length - #component

				local prefix_length = 1
				while prefix_length + 1 <= #component and not component:sub(prefix_length, prefix_length):match("%a") do
					prefix_length = prefix_length + 1
				end
				components[i] = component:sub(1, prefix_length)

				total_length = total_length + #components[i]
			end

			if vim.bo.modified and #components > 0 then
				components[#components] = components[#components] .. " ●"
			end

			return prefix .. table.concat(components, "/")
		end

		vim.api.nvim_create_autocmd("CmdlineEnter", {
			pattern = "/,?",
			callback = function()
				vim.g.lualine_show_search_index = true
			end,
		})

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
		notification_util:append_callback_on_notify(function()
			require("lualine").refresh()
		end)

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
				lualine_a = { mode },
				lualine_b = {
					{
						macro_recording,
						color = { bg = "#ff2211", fg = "#ffffff" },
					},
					"branch",
				},
				lualine_c = {
					luaLineShortenedPath,
					"diff",
					"diagnostics",
					"searchcount",
					"selectioncount",
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
				lualine_y = {
					"lsp_status",
				},
				lualine_z = { "location" },
			},
			inactive_sections = {
				lualine_c = { luaLineShortenedPath },
			},
		})
	end,
}
