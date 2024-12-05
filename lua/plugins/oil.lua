return {
	{
		"stevearc/oil.nvim",
		---@module 'oil'
		---@type oil.SetupOpts
		opts = {},
		dependencies = { { "echasnovski/mini.icons", opts = {} } },
		config = function()
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
				default_file_explorer = true,
				columns = { "icon" },
				lsp_file_methods = {
					enabled = true,
					timeout_ms = 1000,
					autosave_changes = true,
				},
				view_options = {
					show_hidden = true,
				},

				keymaps = {
					["<leader>td"] = {
						desc = "[T]oggle [D]etails",
						callback = function()
							show_details = not show_details
							if show_details then
								require("oil").set_columns({
									"icon",
									"size",
									"mtime",
									"permissions",
								})
							else
								require("oil").set_columns({ "icon" })
							end
						end,
					},
					["g?"] = { "actions.show_help", mode = "n" },
					["<CR>"] = "actions.select",
					["<C-s>"] = { "actions.select", opts = { vertical = true } },
					["<C-t>"] = { "actions.select", opts = { tab = true } },
					["<C-p>"] = "actions.preview",
					["<C-c>"] = { "actions.close", mode = "n" },
					["<C-l>"] = "actions.refresh",
					["-"] = { "actions.parent", mode = "n" },
					["_"] = { "actions.open_cwd", mode = "n" },
					["`"] = { "actions.cd", mode = "n" },
					["~"] = { "actions.cd", opts = { scope = "tab" }, mode = "n" },
					["gs"] = { "actions.change_sort", mode = "n" },
					["gx"] = "actions.open_external",
					["g."] = { "actions.toggle_hidden", mode = "n" },
					["g\\"] = { "actions.toggle_trash", mode = "n" },
				},

				use_default_keymaps = false,
				win_options = {
					signcolumn = "yes:2",
					winbar = "%!v:lua.get_oil_winbar()",
				},
			})

			vim.keymap.set("n", "<leader>pv", ":Oil<CR>", { desc = "[P]roject [V]iew (Oil)" })
		end,
	},
}
