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
					-- vim.notify = require("notify") -- Set as the default notify handler
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
					enabled = false,
				},

				routes = {
					{
						view = "cmdline",
						filter = { event = "msg_showmode" },
					},
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
