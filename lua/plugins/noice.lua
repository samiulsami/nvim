return {
	{
		"folke/noice.nvim",
		event = "VeryLazy",
		dependencies = {
			-- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
			"MunifTanjim/nui.nvim",
			commit = "13fbbcbe815c3bbbb8c5977a12cfb0b9318deaf8",
		},
		config = function()
			require("noice").setup({
				messages = {
					enabled = true,
					view = "notify",
					view_warn = "notify",
					view_error = "notify",
					view_search = "virtualtext",
					view_history = "messages",
				},
				routes = {
					{
						view = "cmdline",
						filter = { event = "msg_showmode" },
					},

					{ filter = { find = "E162" }, view = "mini" },
					{ filter = { event = "msg_show", kind = "", find = "written" }, view = "mini" },
					{ filter = { event = "emsg", find = "E23" }, opts = { skip = true } },
					{ filter = { event = "emsg", find = "E20" }, opts = { skip = true } },
					{ filter = { find = "No signature help" }, opts = { skip = true } },
					{ filter = { find = "E37" }, opts = { skip = true } },

					{ -- pipe undo/redo messages into mini view
						filter = {
							event = "msg_show",
							cond = function(message)
								return (message:content():match("change") or message:content():match("line"))
									and (message:content():match("before") or message:content():match("after"))
							end,
							max_height = 1,
						},
						view = "mini",
					},
					{ -- filter out buffer change messages and messages that contain the current buffer
						filter = {
							event = "msg_show",
							cond = function(message)
								return message:content():find(vim.fn.expand("%"))
							end,
							max_height = 1,
						},
						skip = true,
					},
					{ -- filter out messages that contain the home directory
						filter = {
							event = "msg_show",
							cond = function(message)
								return message:content():find(vim.fn.expand("~"))
							end,
							max_height = 1,
						},
						skip = true,
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
