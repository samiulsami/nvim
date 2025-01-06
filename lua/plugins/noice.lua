return {
	{
		"folke/noice.nvim",
		event = "VeryLazy",
		dependencies = {
			-- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
			"MunifTanjim/nui.nvim",
			-- OPTIONAL:
			--   `nvim-notify` is only needed, if you want to use the notification view.
			--   If not available, we use `mini` as the fallback
			{
				"rcarriga/nvim-notify",
				config = function()
					vim.notify = require("notify") -- Set as the default notify handler
					require("notify").setup({
						background_colour = "#101010",
						stages = "fade",
						timeout = 0,
					})
				end,
				event = "VeryLazy", -- Load after other plugins
			},
		},
		config = function()
			require("noice").setup({
				messages = {
					enabled = true,
					view = "notify",
					view_warn = "notify",
					view_error = "notify",
					view_search = "cmdline",
					view_history = "messages",
				},

				routes = {

					{ filter = { find = "E162" }, view = "mini" },
					{ filter = { event = "msg_show", kind = "", find = "written" }, view = "mini" },
					-- { filter = { event = "msg_show", find = "search hit BOTTOM" }, skip = true },
					-- { filter = { event = "msg_show", find = "search hit TOP" }, skip = true },
					{ filter = { event = "emsg", find = "E23" }, skip = true },
					{ filter = { event = "emsg", find = "E20" }, skip = true },
					{ filter = { find = "No signature help" }, skip = true },
					{ filter = { find = "E37" }, skip = true },
					{
						view = "cmdline",
						filter = { event = "msg_showmode" },
					},
				},
				notify = {
					-- Noice can be used as `vim.notify` so you can route any notification like other messages
					-- Notification messages have their level and other properties set.
					-- event is always "notify" and kind can be any log level as a string
					-- The default routes will forward notifications to nvim-notify
					-- Benefit of using Noice for this is the routing and consistent history view
					enabled = true,
					view = "notify",
				},
				-- you can enable a preset for easier configuration
				presets = {
					bottom_search = true, -- use a classic bottom cmdline for search
					command_palette = true, -- position the cmdline and popupmenu together
					long_message_to_split = true, -- long messages will be sent to a split
					inc_rename = false, -- enables an input dialog for inc-rename.nvim
					lsp_doc_border = false, -- add a border to hover docs and signature help
				},
			})
		end,
	},
}
