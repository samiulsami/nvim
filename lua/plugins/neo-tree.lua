return {
	{
		"nvim-neo-tree/neo-tree.nvim",
		event = "VimEnter",
		version = "*",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
			"MunifTanjim/nui.nvim",
			{
				"s1n7ax/nvim-window-picker",
				version = "2.*",
				config = function()
					require("window-picker").setup({
						filter_rules = {
							include_current_win = false,
							autoselect_one = true,
							-- filter using buffer options
							bo = {
								-- if the file type is one of following, the window will be ignored
								filetype = { "neo-tree", "neo-tree-popup", "notify" },
								-- if the buffer type is one of following, the window will be ignored
								buftype = { "terminal", "quickfix" },
							},
						},
					})
				end,
			},
		},
		keys = {
			{
				"\\",
				":Neotree toggle<CR>",
				desc = "NeoTree reveal",
				{
					silent = true,
					desc = "[N]eotree [R]eveal",
				},
			},

			{
				"<leader>NB",
				function()
					require("neo-tree.command").execute({
						source = "buffers",
						position = "left",
					})
				end,
				desc = "[N]eotree [B]uffers",
			},

			{
				"<leader>NG",
				function()
					require("neo-tree.command").execute({
						source = "git_status",
						position = "left",
					})
				end,
				desc = "[N]eotree [G]it status",
			},
			{
				"<leader>NR",
				function()
					require("neo-tree.sources.manager").refresh("filesystem")
				end,
				desc = "[N]eotree [R]efresh",
			},
		},

		config = function()
			vim.fn.sign_define("DiagnosticSignError", { text = " ", texthl = "DiagnosticSignError" })
			vim.fn.sign_define("DiagnosticSignWarn", { text = " ", texthl = "DiagnosticSignWarn" })
			vim.fn.sign_define("DiagnosticSignInfo", { text = " ", texthl = "DiagnosticSignInfo" })
			vim.fn.sign_define("DiagnosticSignHint", { text = "󰌵", texthl = "DiagnosticSignHint" })

			require("neo-tree").setup({
				event_handlers = {
					{
						event = "neo_tree_buffer_enter",
						handler = function()
							vim.cmd("highlight! Cursor blend=100")
							vim.cmd("set number relativenumber")
						end,
					},
					{
						event = "neo_tree_buffer_leave",
						handler = function()
							vim.cmd("highlight! Cursor guibg=#5f87af blend=0")
						end,
					},
				},
				close_if_last_window = false, -- Close Neo-tree if it is the last window left in the tab
				popup_border_style = "rounded",
				enable_git_status = true,
				enable_diagnostics = true,
				filesystem = {
					components = {
						harpoon_index = function(config, node, _)
							local harpoon_list = require("harpoon"):list()
							local path = node:get_id()
							local harpoon_key = vim.uv.cwd()

							for i, item in ipairs(harpoon_list.items) do
								local value = item.value
								if string.sub(item.value, 1, 1) ~= "/" then
									value = harpoon_key .. "/" .. item.value
								end

								if value == path then
									vim.print(path)
									return {
										text = string.format(" ⥤ %d", i), -- <-- Add your favorite harpoon like arrow here
										highlight = config.highlight or "NeoTreeDirectoryIcon",
									}
								end
							end
							return {}
						end,
					},
					renderers = {
						file = {
							{ "icon" },
							{ "name", use_git_status_colors = true },
							{ "harpoon_index" }, --> This is what actually adds the component in where you want it
							{ "diagnostics" },
							{ "git_status", highlight = "NeoTreeDimText" },
						},
					},
					filtered_items = {
						visible = true,
						hide_hidden = false,
						hide_gitignored = false,
						hide_dotfiles = false,
					},
					window = {
						position = "left",
						width = 35,
					},
					follow_current_file = {
						enabled = true, -- This will find and focus the file in the active buffer every time
						--               -- the current file is changed while the tree is open.
						leave_dirs_open = true, -- `false` closes auto expanded dirs, such as with `:Neotree reveal`
					},
					hijack_netrw_behavior = "open_default", -- netrw disabled, opening a directory opens neo-tree
					-- in whatever position is specified in window.position
					-- "open_current",  -- netrw disabled, opening a directory opens within the
					-- window like netrw would, regardless of window.position
					-- "disabled",    -- netrw left alone, neo-tree does not handle opening dirs
					use_libuv_file_watcher = true,
				},

				buffers = {
					follow_current_file = {
						enabled = true, -- This will find and focus the file in the active buffer every time
						--              -- the current file is changed while the tree is open.
						leave_dirs_open = true, -- `false` closes auto expanded dirs, such as with `:Neotree reveal`
					},
					show_unloaded = true,
				},
			})

			vim.api.nvim_create_autocmd("BufWinEnter", {
				pattern = "*",
				callback = function()
					if vim.bo.filetype == "neo-tree" then
						vim.defer_fn(function()
							vim.cmd("wincmd l")
						end, 0)
					end
				end,
			})

			require("neo-tree.sources.manager").refresh("filesystem")
		end,
	},
}
