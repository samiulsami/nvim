return {
	{

		"folke/snacks.nvim",
		opts = {
			picker = {
				matcher = {
					fuzzy = true,
					smartcase = true,
					ignorecase = true,
					sort_empty = false,
					filename_bonus = true,
					file_pos = true,
					cwd_bonus = true,
					frecency = true,
				},
				ui_select = true,
				formatters = {
					file = {
						filename_first = true,
						truncate = 40,
						filename_only = false,
						icon_width = 2,
						git_status_hl = true,
					},
					selected = {
						show_always = false,
						unselected = false,
					},
				},
				sources = {
					explorer = {
						diagnostics_open = false,
						git_status = true,
						git_status_open = false,
						auto_close = false,
						jump = { close = false },
						layout = { preset = "sidebar", preview = false },
						matcher = { sort_empty = false, fuzzy = true },
						config = function(opts)
							return require("snacks.picker.source.explorer").setup(opts)
						end,
					},
				},
				win = {
					-- input window
					input = {
						keys = {
							["<a-d>"] = { "preview_scroll_down", mode = { "i", "n" } },
							["<a-u>"] = { "preview_scroll_up", mode = { "i", "n" } },
						},
					},
					list = {
						keys = {
							["<ESC>"] = { "", mode = { "i", "n" } },
						},
					},
				},
			},
		},

		-- stylua: ignore
		keys = {
			{ "<leader><space>", function() Snacks.picker.smart() end, desc = "Smart Find Files" },
			{ "<leader>,", function() Snacks.picker.buffers() end, desc = "Buffers" },
			{ "<leader>sn", function() Snacks.picker.notifications() end, desc = "Notification History" },
			{ "<leader>p", function() Snacks.explorer() end, desc = "[P]roject View" },
			-- find
			{ "<leader>fb", function() Snacks.picker.buffers() end, desc = "Buffers" },
			{ "<leader>fc", function() Snacks.picker.files({ cwd = vim.fn.stdpath("config") }) end, desc = "Find Config File" },
			{ "<leader>sf", function() Snacks.picker.files() end, desc = "Search Files" },
			{ "<leader>fg", function() Snacks.picker.git_files() end, desc = "Find Git Files" },
			{ "<leader>sp", function() Snacks.picker.projects() end, desc = "Projects" },
			{ "<leader>ff", function() Snacks.picker.recent() end, desc = "Recent" },
			-- Grep
			{ "<leader>/", function() Snacks.picker.lines() end, desc = "Buffer Lines" },
			{ "<leader>sg", function() Snacks.picker.grep() end, desc = "Grep" },
			{ "<leader>sw", function() Snacks.picker.grep_word() end, desc = "Grep Word" },
			{ '<leader>s"', function() Snacks.picker.registers() end, desc = "Registers" },
			{ "<leader>s/", function() Snacks.picker.search_history() end, desc = "Search History" },
			{ "<leader>sa", function() Snacks.picker.autocmds() end, desc = "Autocmds" },
			{ "<leader>sc", function() Snacks.picker.command_history() end, desc = "Command History" },
			{ "<leader>sC", function() Snacks.picker.commands() end, desc = "Commands" },
			{ "<leader>sd", function() Snacks.picker.diagnostics() end, desc = "Diagnostics" },
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
			{ "<leader>uC", function() Snacks.picker.colorschemes() end, desc = "Colorschemes" },
			-- LSP
			{ "gd", function() Snacks.picker.lsp_definitions() end, desc = "Goto Definition" },
			{ "gD", function() Snacks.picker.lsp_declarations() end, desc = "Goto Declaration" },
			{ "gr", function() Snacks.picker.lsp_references() end, nowait = true, desc = "References" },
			{ "gi", function() Snacks.picker.lsp_implementations() end, desc = "Goto Implementation" },
			{ "gy", function() Snacks.picker.lsp_type_definitions() end, desc = "Goto T[y]pe Definition" },
			{ "<leader>ds", function() Snacks.picker.lsp_symbols() end, desc = "[D]ocument [S]ymbols" },
			{ "<leader>ws", function() Snacks.picker.lsp_workspace_symbols() end, desc = "[W]orkspace [S]ymbols" },
		},
	},
	{
		"folke/todo-comments.nvim",
		optional = true,
		-- stylua: ignore
		keys = {
			{ "<leader>st", function() Snacks.picker.todo_comments() end, desc = "Todo" },
			{ "<leader>sT", function() Snacks.picker.todo_comments({ keywords = { "TODO", "FIX", "FIXME" } }) end, desc = "Todo/Fix/Fixme" },
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
