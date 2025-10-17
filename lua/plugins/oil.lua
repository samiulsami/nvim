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
							local current_dir = require("oil").get_current_dir()
							local tmux_command = "tmux split-window 'cd " .. current_dir .. " && exec $SHELL'"
							os.execute(tmux_command)
						end,
					},
					["<ESC>"] = {
						mode = "n",
						desc = "Close Oil",
						callback = function()
							require("oil").close()
						end,
					},
					["<leader>sg"] = {
						function()
							require("fzf-lua").live_grep({
								cwd_prompt = true,
								cwd = require("oil").get_current_dir(),
								search = "",
							})
						end,
						mode = "n",
						nowait = true,
						desc = "Grep in current oil directory",
					},
					["<leader>sf"] = {
						function()
							require("fzf-lua").files({
								cwd_prompt = true,
								cwd = require("oil").get_current_dir(),
								file_ignore_patterns = {},
							})
						end,
						mode = "n",
						nowait = true,
						desc = "Search in Current oil directory",
					},
				},

				watch_for_changes = true,
				constrain_cursor = "editable",
			})

			local oil_buf_name = nil
			vim.keymap.set("n", "<leader>p", function()
				if oil_buf_name and vim.api.nvim_buf_get_name(0) == oil_buf_name then
					pcall(require("oil").close)
					return
				end
				require("oil").open()
				vim.schedule(function()
					oil_buf_name = vim.api.nvim_buf_get_name(0)
				end)
			end, { desc = "Toggle Oil Project View" })
		end,
	},
}
