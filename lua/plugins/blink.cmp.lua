return {
	{
		"saghen/blink.cmp",
		dependencies = {
			"rafamadriz/friendly-snippets",
			"saghen/blink.compat",
			{
				"folke/lazydev.nvim",
				ft = "lua",
				opts = { library = { { path = "luvit-meta/library", words = { "vim%.uv" } } } },
				dependencies = {
					{ "Bilal2453/luvit-meta", lazy = true },
				},
			},
			"dmitmel/cmp-cmdline-history",
			{
				"samiulsami/cmp-go-deep",
				dependencies = { "kkharji/sqlite.lua" },
			},
			{ "Snikimonkd/cmp-go-pkgs" },
		},
		build = "cargo build --release",

		---@module 'blink.cmp'
		---@type blink.cmp.Config
		opts = {
			keymap = {
				preset = "default",
				["<CR>"] = {},
				["<C-b>"] = { "scroll_documentation_up", "fallback" },
				["<C-f>"] = { "scroll_documentation_down", "fallback" },
			},

			sources = {
				default = { "lsp", "path", "buffer", "go_deep", "go_pkgs", "snippets", "lazydev" },
				providers = {
					snippets = {
						name = "snippets",
						module = "blink.cmp.sources.snippets",
						max_items = 3,
						score_offset = 1,
						min_keyword_length = 0,
					},
					buffer = {
						name = "buffer",
						module = "blink.cmp.sources.buffer",
						max_items = 3,
						score_offset = 2,
						min_keyword_length = 2,
					},
					lsp = {
						name = "lsp",
						module = "blink.cmp.sources.lsp",
						max_items = 5,
						score_offset = 100000000,
						min_keyword_length = 2,
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
							db_size_limit_bytes = 200 * 1024 * 1024,
							filetypes = { "go" },
						},
						max_items = 3,
						min_keyword_length = 3,
						score_offset = -10000,
					},
					cmdline = {
						name = "cmdline",
						module = "blink.cmp.sources.cmdline",
						max_items = 10,
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
						max_items = 5,
						score_offset = -100,
						min_keyword_length = 0,
					},
					cmdline_history = {
						name = "cmdline_history",
						module = "blink.compat.source",
						timeout_ms = 100,
						max_items = 2,
						min_keyword_length = 0,
						score_offset = -100000000,
						transform_items = function(_, items)
							for _, item in ipairs(items) do
								item.kind_name = "HISTORY"
								item.kind_icon = "  "
							end
							return items
						end,
					},
					lazydev = {
						name = "LazyDev",
						module = "lazydev.integrations.blink",
						score_offset = 100,
						max_items = 3,
						min_keyword_length = 0,
					},
				},
			},

			cmdline = {
				sources = function()
					local type = vim.fn.getcmdtype()
					if type == "/" or type == "?" then
						return { "cmdline_buffer", "cmdline_history" }
					end
					if type == ":" or type == "@" then
						return {
							"path",
							"lazydev",
							"cmdline",
							"cmdline_buffer",
							"cmdline_history",
						}
					end
					return {}
				end,
				keymap = {
					preset = "inherit",
					["<CR>"] = {},
				},
				completion = {
					ghost_text = { enabled = false },
					menu = { auto_show = true },
				},
			},

			completion = {
				accept = { auto_brackets = { enabled = false } },
				list = { selection = { auto_insert = false } },
				ghost_text = { enabled = false },
				menu = {
					winblend = 15,
					auto_show = true,
					direction_priority = { "n", "s" },
					draw = {
						columns = { { "label", "label_description", gap = 1 }, { "kind_icon", "kind" } },
					},
				},
				documentation = {
					auto_show = true,
					auto_show_delay_ms = 0,
					update_delay_ms = 50,
					window = { winblend = 5 },
				},
			},

			appearance = {
				use_nvim_cmp_as_default = false,
				nerd_font_variant = "mono",
			},

			signature = {
				enabled = true,
			},
			fuzzy = {
				implementation = "prefer_rust_with_warning",
			},
		},
		opts_extend = { "sources.default" },
	},
}
