return {
	{
		"saghen/blink.cmp",
		dependencies = {
			"saghen/blink.compat",
			{
				"samiulsami/cmp-go-deep",
				dependencies = { "kkharji/sqlite.lua" },
			},
		},
		build = "cargo build --release",

		---@module 'blink.cmp'
		---@type blink.cmp.Config
		opts = {
			keymap = {
				preset = "default",
				["<CR>"] = {
					function(cmp)
						if cmp.is_menu_visible() then
							return vim.fn.getcmdtype() ~= "" and cmp.accept_and_enter() or cmp.accept()
						end
					end,
					"fallback",
				},
				["<C-n>"] = {
					function(cmp)
						if cmp.is_menu_visible() then
							return cmp.select_next()
						end
					end,
					"show",
				},
				["<C-p>"] = {
					function(cmp)
						if cmp.is_menu_visible() then
							return cmp.select_prev()
						end
					end,
					"show",
				},
				["<C-d>"] = { "show_documentation", "hide_documentation", "fallback" },
				["<C-b>"] = { "scroll_documentation_down", "fallback" },
				["<C-f>"] = { "scroll_documentation_up", "fallback" },
			},

			sources = {
				default = { "lsp", "path", "buffer", "go_deep", "go_pkgs" },
				providers = {
					buffer = {
						name = "buffer",
						module = "blink.cmp.sources.buffer",
						max_items = 5,
						score_offset = 2,
						min_keyword_length = 0,
					},
					lsp = {
						name = "lsp",
						module = "blink.cmp.sources.lsp",
						max_items = 99999,
						score_offset = 100000000,
						min_keyword_length = 0,
					},
					go_pkgs = {
						name = "go_pkgs",
						module = "blink.compat.source",
						min_keyword_length = 0,
					},
					go_deep = {
						name = "go_deep",
						module = "blink.compat.source",
						opts = {
							debounce_cache_requests_ms = 0,
							debounce_gopls_requests_ms = 0,
							filetypes = { "go" },
						},
						max_items = 10,
						min_keyword_length = 0,
						score_offset = -10000,
					},
					cmdline = {
						name = "cmdline",
						module = "blink.cmp.sources.cmdline",
						max_items = 9999,
						min_keyword_length = 0,
						score_offset = -1000,
						transform_items = function(_, items)
							for _, item in ipairs(items) do
								item.kind_name = "CMDLINE"
								item.kind_icon = "  "
							end
							return items
						end,
					},
					cmdline_buffer = {
						name = "buffer",
						module = "blink.cmp.sources.buffer",
						max_items = 9999,
						score_offset = -100,
						min_keyword_length = 0,
					},
				},
			},

			cmdline = {
				sources = function()
					local cmd_type, cmd_win_type = vim.fn.getcmdtype(), vim.fn.getcmdwintype()
					local type = cmd_type == "" and cmd_win_type or cmd_type
					if type == "/" or type == "?" then
						return { "cmdline_buffer" }
					end
					if type == ":" or type == "@" then
						return {
							"path",
							"cmdline",
							"cmdline_buffer",
						}
					end
					return {}
				end,
				keymap = {
					preset = "inherit",
					["<CR>"] = {},
				},
				completion = {
					list = { selection = { preselect = true, auto_insert = true } },
					ghost_text = { enabled = false },
					menu = { auto_show = false },
				},
			},

			completion = {
				accept = { auto_brackets = { enabled = false } },
				list = { selection = { preselect = true, auto_insert = true } },
				ghost_text = { enabled = false, show_with_menu = false },
				menu = {
					winblend = 0,
					auto_show = false,
					direction_priority = { "n", "s" },
					draw = {
						columns = { { "label", "label_description", gap = 1 }, { "kind_icon", "kind" } },
					},
				},
				documentation = {
					auto_show = false,
					auto_show_delay_ms = 0,
					update_delay_ms = 50,
					window = { winblend = 0 },
				},
			},

			appearance = {
				use_nvim_cmp_as_default = false,
				nerd_font_variant = "mono",
			},

			signature = {
				enabled = true,
				window = {
					show_documentation = false,
				},
			},

			fuzzy = {
				implementation = "prefer_rust_with_warning",
			},
		},
		opts_extend = { "sources.default" },
	},
}
