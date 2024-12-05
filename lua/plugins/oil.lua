return {
	{
		"stevearc/oil.nvim",
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
								require("oil").set_columns(columns)
							else
								require("oil").set_columns({ "icon" })
							end
						end,
					},
				},

				win_options = {
					winbar = "%!v:lua.get_oil_winbar()",
				},
			})
		end,
	},
}
