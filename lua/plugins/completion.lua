return {
	{
		"saghen/blink.cmp",
		dependencies = {
			"rafamadriz/friendly-snippets",
			"mikavilpas/blink-ripgrep.nvim",
		},
		version = "v0.*",
		config = function()
			local opts = {
				keymap = { preset = "default" },
				sources = {
					default = { "lsp", "path", "snippets", "buffer", "ripgrep" },
					cmdline = {},
				},

				completion = {
					menu = {
						winblend = 15,
						draw = {
							padding = { 1, 0 },
							columns = { { "label", "label_description", gap = 1 }, { "kind_icon", "kind" } },
							components = {
								kind_icon = { width = { fill = true } },
							},
						},
					},

					documentation = {
						auto_show = true,
						auto_show_delay_ms = 100,
						update_delay_ms = 100,
						window = {
							winblend = 10,
						},
					},
				},
				appearance = {
					use_nvim_cmp_as_default = false,
					nerd_font_variant = "mono",
				},

				signature = { enabled = true },
			}

			require("blink.cmp").setup(opts)
		end,
	},

	{
		"hrsh7th/nvim-cmp",
		event = { "InsertEnter", "CmdlineEnter" },
		dependencies = {
			"dmitmel/cmp-cmdline-history",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-cmdline",
			{
				"petertriho/cmp-git",
				config = function()
					require("cmp_git").setup()
				end,
			},
		},
		config = function()
			local cmp = require("cmp")
			local buffer_source = {
				name = "buffer",
				keyword_length = 2,
				max_item_count = 10,
				option = {
					get_bufnrs = function()
						local buf = vim.api.nvim_get_current_buf()
						local byte_size = vim.api.nvim_buf_get_offset(buf, vim.api.nvim_buf_line_count(buf))
						if byte_size > 1024 * 1024 then -- 1MB MAX
							return {}
						end
						return { buf }
					end,
				},
			}

			cmp.setup.cmdline({ "/", "?" }, {
				mapping = cmp.mapping.preset.cmdline(),
				sources = {
					buffer_source,
				},
			})

			cmp.setup.cmdline(":", {
				mapping = cmp.mapping.preset.cmdline(),
				sources = cmp.config.sources({
					{ name = "cmdline_history", keyword_length = 2 },
					{ name = "path", keyword_length = 3 },
					{ name = "cmdline", keyword_length = 2 },
					{ name = "git" },
					buffer_source,
				}),
				matching = { disallow_symbol_nonprefix_matching = false },
			})
		end,
	},
}
