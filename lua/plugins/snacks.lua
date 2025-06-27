local picker_ignore_patterns = {
	"node_modules/*",
	"^.git/*",
	"vendor/*",
	"zz_generated*",
	"openapi_generated*",
}

return {
	{
		"folke/snacks.nvim",
		---@type snacks.Config
		opts = {
			bigfile = { enabled = true, size = 10 * 1024 * 1024 },
			indent = { enabled = true, animate = { enabled = false } },
			input = { enabled = false },
			quickfile = { enabled = true },
			statuscolumn = { enabled = true },
			words = { enabled = true, debounce = 50 },
			notifier = { enabled = true, timeout = 1500, keys = { q = "close" } },
			explorer = { enabled = false },
			picker = {
				enabled = true,
				matcher = {
					fuzzy = true,
					smartcase = true,
					ignorecase = true,
					sort_empty = false,
					filename_bonus = true,
					file_pos = true,
					cwd_bonus = true,
					history_bonus = true,
					frecency = true,
				},
				ui_select = true,
				formatters = {
					file = {
						filename_first = true,
						truncate = 1000,
						filename_only = false,
						icon_width = 2,
						git_status_hl = true,
					},
					selected = {
						show_always = false,
						unselected = false,
					},
				},
				layout = {
					layout = {
						box = "vertical",
						backdrop = false,
						width = 0.999,
						height = 0.999,
						border = "none",
						{
							box = "vertical",
							{
								win = "input",
								height = 1,
								border = "rounded",
								title = "{title} {live} {flags}",
								title_pos = "center",
							},
							{
								win = "list",
								title = " Results ",
								title_pos = "center",
								border = "rounded",
							},
						},
						{
							win = "preview",
							title = "{preview:Preview}",
							width = 0.999,
							height = 0.45,
							border = "rounded",
							title_pos = "center",
						},
					},
				},

				sources = {
					---@type snacks.picker.explorer.Config
					explorer = {
						enabled = false,
						hidden = true,
						auto_close = true,
						jump = { close = true },
						layout = {
							preview = false,
							layout = {
								box = "horizontal",
								backdrop = false,
								width = 0.999,
								height = 0.999,
								border = "none",
								{
									box = "vertical",
									{ win = "list", title = " Results ", title_pos = "center", border = "rounded" },
									{
										win = "input",
										height = 1,
										border = "rounded",
										title = "{title} {live} {flags}",
										title_pos = "center",
									},
								},
								{
									win = "preview",
									title = "{preview:Preview}",
									width = 0.55,
									border = "rounded",
									title_pos = "center",
								},
							},
						},
						matcher = { sort_empty = false, fuzzy = true },
						config = function(opts)
							return require("snacks.picker.source.explorer").setup(opts)
						end,
						win = {
							list = {
								wo = {
									number = true,
									relativenumber = true,
								},
							},
						},
					},
				},

				win = {
					input = {
						keys = {
							["<C-y>"] = { "confirm", mode = { "i", "n" } },
							["<a-d>"] = { "preview_scroll_down", mode = { "i", "n" } },
							["<a-u>"] = { "preview_scroll_up", mode = { "i", "n" } },
						},
					},
					list = {
						wo = {
							number = true,
							relativenumber = true,
						},
						keys = {
							["l"] = { "confirm", mode = { "i", "n" } },
							["<C-p>"] = { "toggle_preview", mode = { "i", "n" } },
							["<ESC>"] = { "close", mode = { "i", "n" } },
							["<A-h>"] = {
								function()
									vim.cmd("vertical resize -4")
								end,
								mode = { "i", "n" },
							},
							["<A-u>"] = "preview_scroll_up",
							["<A-d>"] = "preview_scroll_down",
						},
					},
				},
			},
		},

		-- stylua: ignore
		keys = {
			{ "<leader>gp", function() Snacks.gitbrowse() end, mode = { "n", "v" }, { desc = "[G]ithub [P]review" } },
			{ "<leader>E", function() Snacks.explorer.open() end, { desc = "snacks.explorer" } },

			{ "<leader>ff", function() Snacks.picker.smart({hidden = true, ignored = true}) end, desc = "Smart Find Files" },
			{ "<leader>,", function() Snacks.picker.buffers({hidden = true, ignored = true}) end, desc = "Buffers" },
			{ "<leader>sn", function() Snacks.picker.notifications() end, desc = "Notification History" },
			-- { "<leader>p", function() Snacks.explorer() end, desc = "[P]roject View" },

			{ "<leader>sf", function() Snacks.picker.files({exclude = picker_ignore_patterns, hidden = true, ignored = true}) end, desc = "Search Files" },
			{ "<leader>sF", function() Snacks.picker.files({title = "Search All Files", hidden = true, ignored = true}) end, desc = "ALL Search Files" },
			{ "<leader>sg", function() Snacks.picker.grep({exclude = picker_ignore_patterns, hidden = true, ignored = true}) end, desc = "Grep" },
			{ "<leader>sG", function() Snacks.picker.grep({title = "Grep All Files", hidden = true, ignored = true}) end, desc = "ALL Grep" },
			{ "<leader>sw", function() Snacks.picker.grep_word({exclude = picker_ignore_patterns, hidden = true, ignored = true}) end, desc = "Grep Word" },
			{ "<leader>sW", function() Snacks.picker.grep_word({title = "Grep Word All Files", hidden = true, ignored = true}) end, desc = "ALL Grep Word" },

			{ "<leader>fg", function() Snacks.picker.git_files() end, desc = "Find Git Files" },
			{ "<leader>sp", function() Snacks.picker.projects() end, desc = "Projects" },
			{ "<leader><space>", function() Snacks.picker.recent({hidden = true, ignored = true}) end, desc = "Recent" },
			{ "<leader>gs", function() Snacks.picker.git_stash() end, desc = "Git Stash" },

			{ "<leader>/", function() Snacks.picker.lines() end, desc = "Buffer Lines" },
			{ '<leader>s"', function() Snacks.picker.registers() end, desc = "Registers" },
			{ "<leader>s/", function() Snacks.picker.search_history() end, desc = "Search History" },
			{ "<leader>sa", function() Snacks.picker.autocmds() end, desc = "Autocmds" },
			{ "<leader>sc", function() Snacks.picker.command_history() end, desc = "Command History" },
			{ "<leader>sC", function() Snacks.picker.commands() end, desc = "Commands" },
			{ "<leader>sd", function() Snacks.picker.diagnostics({exclude = picker_ignore_patterns}) end, desc = "Diagnostics" },
			{ "<leader>sD", function() Snacks.picker.diagnostics_buffer() end, desc = "Buffer Diagnostics" },
			{ "<leader>sh", function() Snacks.picker.help() end, desc = "Help Pages" },
			{ "<leader>sH", function() Snacks.picker.highlights() end, desc = "Highlights" },
			{ "<leader>sj", function() Snacks.picker.jumps() end, desc = "Jumps" },
			{ "<leader>sk", function() Snacks.picker.keymaps() end, desc = "Keymaps" },
			{ "<leader>sm", function() Snacks.picker.marks() end, desc = "Marks" },
			{ "<leader>sM", function() Snacks.picker.man() end, desc = "Man Pages" },
			{ "<leader>sq", function() Snacks.picker.qflist() end, desc = "Quickfix List" },
			{ "<leader>sr", function() Snacks.picker.resume() end, desc = "Resume" },
			{ "<leader>su", function() Snacks.picker.undo() end, desc = "Undo History" },
			{ "<leader>C", function() Snacks.picker.colorschemes() end, desc = "Colorschemes" },
			-- LSP
			{ "gd", function() Snacks.picker.lsp_definitions() end, desc = "Goto Definition" },
			{ "gD", function() Snacks.picker.lsp_declarations() end, desc = "Goto Declaration" },
			{ "gr", function() Snacks.picker.lsp_references() end, nowait = true, desc = "References" },
			{ "gi", function() Snacks.picker.lsp_implementations() end, desc = "Goto Implementation" },
			{ "gy", function() Snacks.picker.lsp_type_definitions() end, desc = "Goto T[y]pe Definition" },
			{ "<leader>ds", function() Snacks.picker.lsp_symbols({exclude = picker_ignore_patterns, hidden = true, ignored = true}) end, desc = "[D]ocument [S]symbols" },
			{ "<leader>dS", function() Snacks.picker.lsp_symbols() end, desc = "ALL [D]ocument [S]symbols" },
			{ "<leader>ws", function() Snacks.picker.lsp_workspace_symbols({exclude = picker_ignore_patterns, hidden = true, ignored = true}) end, desc = "[W]orkspace [S]symbols" },
			{ "<leader>wS", function() Snacks.picker.lsp_workspace_symbols() end, desc = "ALL [W]orkspace [S]symbols" },
		},
	},
	{
		"folke/todo-comments.nvim",
		optional = true,
		-- stylua: ignore
		keys = {
			{ "<leader>st", function() Snacks.picker.todo_comments({exclude = picker_ignore_patterns}) end, desc = "Todo" },
			{ "<leader>sT", function() Snacks.picker.todo_comments({ exclude = picker_ignore_patterns, keywords = { "TODO", "FIX", "FIXME" }}) end, desc = "Todo/Fix/Fixme" },
		},
	},
	{
		"folke/trouble.nvim",
		optional = true,
		specs = {
			"folke/snacks.nvim",
			opts = function(_, opts)
				return vim.tbl_deep_extend("force", opts or {}, {
					picker = {
						actions = require("trouble.sources.snacks").actions,
						win = {
							input = {
								keys = {
									["<c-t>"] = {
										"trouble_open",
										mode = { "n", "i" },
									},
								},
							},
						},
					},
				})
			end,
		},
	},
}
