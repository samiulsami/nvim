return {
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

		local oil = require("oil")
		local oil_config = require("oil.config")

		function _G.get_oil_winbar()
			local dir = oil.get_current_dir()
			if dir then
				return vim.fn.fnamemodify(dir, ":~")
			else
				return vim.api.nvim_buf_get_name(0)
			end
		end

		local fzf_lua = require("fzf-lua")
		local fzf_lua_actions = require("fzf-lua.actions")

		oil.setup({
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
				max_width = 0.999,
				max_height = 0.999,
				border = nil,
				win_options = {
					winblend = 6,
				},
			},
			view_options = {
				show_hidden = true,
			},

			keymaps = {
				["<leader>td"] = {
					desc = "[T]oggle Oil [D]etails",
					callback = function()
						if #oil_config.columns ~= #columns then
							oil.set_columns(columns)
						else
							oil.set_columns({})
						end
					end,
				},
				["<leader>cp"] = {
					mode = "n",
					desc = "Copy Path",
					callback = function()
						local current_dir = oil.get_current_dir()
						vim.fn.setreg("+", current_dir)
						vim.notify("'" .. current_dir .. "'\ncopied to clipboard", vim.log.levels.INFO)
					end,
				},
				["<leader>T"] = {
					mode = "n",
					desc = "Open a horizontal tmux split on current directory",
					callback = function()
						local dir = oil.get_current_dir()
						local result = vim.fn.system({ "tmux", "split-window", "-c", dir })
						if vim.v.shell_error ~= 0 then
							vim.notify("Failed to open tmux split: " .. result, vim.log.levels.ERROR)
							return
						end
					end,
				},
				["<leader>sg"] = {
					function()
						fzf_lua.live_grep({
							cwd_prompt = true,
							cwd = oil.get_current_dir(),
							search = "",
							actions = {
								["default"] = function(selected, opts)
									oil.close()
									fzf_lua_actions.file_edit(selected, opts)
								end,
							},
						})
					end,
					mode = "n",
					nowait = false,
					desc = "Grep in current oil directory",
				},
				["<leader>sf"] = {
					function()
						fzf_lua.files({
							cwd_prompt = true,
							cwd = oil.get_current_dir(),
							actions = {
								["default"] = function(selected, opts)
									oil.close()
									fzf_lua_actions.file_edit(selected, opts)
								end,
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

		vim.keymap.set("n", "<leader>p", oil.toggle_float, { desc = "Toggle Oil" })
	end,
}
