return {
	{
		"stevearc/oil.nvim",
		---@module 'oil'
		---@type oil.SetupOpts
		opts = {},
		config = function()
			local columns = {
				"size",
				"mtime",
				"permissions",
			}

			function _G.get_oil_winbar()
				local dir = require("oil").get_current_dir()
				if dir then
					return vim.fn.fnamemodify(dir, ":~")
				else
					return vim.api.nvim_buf_get_name(0)
				end
			end

			local actions = require("fzf-lua.actions")

			local function file_edit_close_float(selected, opts)
				local win = vim.api.nvim_get_current_win()
				local config = vim.api.nvim_win_get_config(win)
				if config.relative ~= "" then
					vim.api.nvim_win_close(win, false)
				end
				actions.file_edit(selected, opts)
			end

			local show_details = false
			require("oil").setup({
				default_file_explorer = false,
				columns = {},
				lsp_file_methods = {
					enabled = true,
					autosave_changes = true,
				},
				win_options = {
					wrap = true,
					winbar = "%!v:lua.get_oil_winbar()",
				},

				float = {
					padding = 0,
					max_width = 0.8,
					max_height = 0.9,
					border = nil,
					win_options = {
						winblend = 5,
					},
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
								require("oil").set_columns({})
							end
						end,
					},
					["<leader>cp"] = {
						mode = "n",
						desc = "Copy Path",
						callback = function()
							local current_dir = require("oil").get_current_dir()
							vim.fn.setreg("+", current_dir)
							vim.notify("'" .. current_dir .. "'\ncopied to clipboard", vim.log.levels.INFO)
						end,
					},
					["<leader>T"] = {
						mode = "n",
						desc = "Open a horizontal tmux split on current directory",
						callback = function()
							local tmux_command = "tmux split-window 'cd "
								.. require("oil").get_current_dir()
								.. " && exec $SHELL'"
							local result = vim.fn.system(tmux_command)
							if vim.v.shell_error ~= 0 then
								vim.notify("Failed to open tmux split: " .. result, vim.log.levels.ERROR)
								return
							end
						end,
					},
					["<leader>sg"] = {
						function()
							require("fzf-lua").live_grep({
								cwd_prompt = true,
								cwd = require("oil").get_current_dir(),
								search = "",
								actions = {
									["default"] = file_edit_close_float,
								},
							})
						end,
						mode = "n",
						nowait = false,
						desc = "Grep in current oil directory",
					},
					["<leader>sf"] = {
						function()
							require("fzf-lua").files({
								cwd_prompt = true,
								cwd = require("oil").get_current_dir(),
								actions = {
									["default"] = file_edit_close_float,
								},
							})
						end,
						mode = "n",
						nowait = false,
						desc = "Search in Current oil directory",
					},
				},

				watch_for_changes = true,
				constrain_cursor = "editable",
			})

			vim.keymap.set("n", "<leader>p", function()
				if vim.api.nvim_buf_get_name(0):match("^oil:///") then
					pcall(require("oil").close)
					return
				end
				require("oil").open_float()
			end, { desc = "Toggle Oil Project View" })
		end,
	},
}
