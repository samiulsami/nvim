return {
	{
		"stevearc/oil.nvim",
		event = "VeryLazy",
		---@module 'oil'
		---@type oil.SetupOpts
		opts = {},
		dependencies = { { "echasnovski/mini.icons", opts = {} } },
		config = function()
			local columns = {
				"icon",
				"size",
				"mtime",
				"permissions",
			}

			function _G.get_oil_winbar()
				local dir = require("oil").get_current_dir()
				if dir then
					return vim.fn.fnamemodify(dir, ":~")
				else
					-- If there is no current directory (e.g. over ssh), just show the buffer name
					return vim.api.nvim_buf_get_name(0)
				end
			end

			local show_details = false
			require("oil").setup({
				default_file_explorer = true,
				columns = { "icon" },
				lsp_file_methods = {
					enabled = true,
					autosave_changes = true,
				},
				win_options = {
					wrap = true,
					winbar = "%!v:lua.get_oil_winbar()",
				},

				view_options = {
					show_hidden = true,
				},

				keymaps = {
					["<leader>td"] = {
						desc = "[T]oggle Oil [D]etails",
						callback = function()
							show_details = not show_details
							if show_details then
								require("oil").set_columns(columns)
							else
								require("oil").set_columns({ "icon" })
							end
						end,
					},
					["<ESC>"] = {
						mode = "n",
						desc = "[T]oggle Oil [D]etails",
						callback = function()
							require("oil").close()
						end,
					},
					["<leader>sg"] = {
						function()
							require("fzf-lua").grep({ cwd = require("oil").get_current_dir(), search = "" })
						end,
						mode = "n",
						nowait = true,
						desc = "Grep in current oil directory",
					},
					["<leader>sf"] = {
						function()
							require("fzf-lua").files({
								cwd_header = false,
								cwd = require("oil").get_current_dir(),
								file_ignore_patterns = {},
							})
						end,
						mode = "n",
						nowait = true,
						desc = "Search in Current oil directory",
					},
				},

				skip_confirm_for_simple_edits = false,

				watch_for_changes = true,
				constrain_cursor = "editable",
			})

			vim.keymap.set("n", "<leader>p", function()
				if vim.api.nvim_buf_get_name(0):match("oil:///") then
					require("oil").close()
					return
				end
				require("oil").open()
			end, { desc = "Toggle Oil Project View" })
		end,
	},
}
