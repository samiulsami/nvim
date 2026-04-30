return {
	"barrettruth/canola.nvim",
	branch = "canola",

	event = "VeryLazy",

	---@module 'canola'
	---@type canola.SetupOpts
	opts = {},
	init = function()
		local columns = {
			"size",
			"mtime",
			"permissions",
		}

		local fzf_lua = require("fzf-lua")
		local fzf_lua_actions = require("fzf-lua.actions")

		---@type canola.config
		vim.g.canola = {
			columns = {},

			lsp = {
				enabled = true,
				autosave = true,
			},

			win = {
				wrap = true,
			},

			float = {
				max_width = 0.999,
				max_height = 0.999,
				border = nil,
				win = {
					winblend = 4,
				},
			},

			hidden = {
				enabled = false,
			},

			keymaps = {
				["<C-h>"] = {
					callback = function()
						local tmux_navigator = require("utils.tmux_navigation")
						tmux_navigator.move_or_tmux(tmux_navigator.direction.LEFT)
					end,
					mode = "n",
					desc = "Move to left window or tmux pane",
				},
				["<C-j>"] = {
					callback = function()
						local tmux_navigator = require("utils.tmux_navigation")
						tmux_navigator.move_or_tmux(tmux_navigator.direction.DOWN)
					end,
					mode = "n",
					desc = "Move to down window or tmux pane",
				},
				["<C-k>"] = {
					callback = function()
						local tmux_navigator = require("utils.tmux_navigation")
						tmux_navigator.move_or_tmux(tmux_navigator.direction.UP)
					end,
					mode = "n",
					desc = "Move to up window or tmux pane",
				},
				["<C-l>"] = {
					callback = function()
						local tmux_navigator = require("utils.tmux_navigation")
						tmux_navigator.move_or_tmux(tmux_navigator.direction.RIGHT)
					end,
					mode = "n",
					desc = "Move to right window or tmux pane",
				},
				["<leader>td"] = {
					callback = function()
						if #require("canola.config").columns ~= #columns then
							require("canola").set_columns(columns)
						else
							require("canola").set_columns({})
						end
					end,
					mode = "n",
					desc = "[T]oggle Canola [D]etails",
				},
				["<leader>cp"] = {
					callback = function()
						local current_dir = require("canola").get_current_dir()
						vim.fn.setreg("+", current_dir)
						vim.notify("'" .. current_dir .. "'\ncopied to clipboard", vim.log.levels.INFO)
					end,
					mode = "n",
					desc = "Copy Path",
				},
				["<leader>T"] = {
					callback = function()
						local result =
							vim.fn.system({ "tmux", "split-window", "-c", require("canola").get_current_dir() })
						if vim.v.shell_error ~= 0 then
							vim.notify("Failed to open tmux split: " .. result, vim.log.levels.ERROR)
							return
						end
					end,
					mode = "n",
					desc = "Open tmux split in current directory",
				},
				["<leader>sg"] = {
					callback = function()
						local canola = require("canola")
						fzf_lua.live_grep({
							cwd_prompt = true,
							cwd = canola.get_current_dir(),
							search = "",
							actions = {
								["default"] = function(selected, opts)
									canola.close()
									fzf_lua_actions.file_edit_or_qf(selected, opts)
								end,
							},
						})
					end,
					mode = "n",
					nowait = false,
					desc = "Grep in current Canola directory",
				},
				["<leader>sf"] = {
					callback = function()
						local canola = require("canola")
						fzf_lua.files({
							cwd_prompt = true,
							cwd = canola.get_current_dir(),
							actions = {
								["default"] = function(selected, opts)
									canola.close()
									fzf_lua_actions.file_edit_or_qf(selected, opts)
								end,
							},
						})
					end,
					mode = "n",
					nowait = false,
					desc = "Search in Current Canola directory",
				},
			},

			watch = true,
			cursor = true,
		}
	end,

	config = function()
		vim.keymap.set("n", "<leader>p", require("canola").toggle_float, { desc = "Toggle Canola" })
	end,
}
