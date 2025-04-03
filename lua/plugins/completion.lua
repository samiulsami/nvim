return {
	{
		"samiulsami/nvim-cmp",
		branch = "feat/above",

		dependencies = {
			{
				"L3MON4D3/LuaSnip",
				build = (function()
					if vim.fn.has("win32") == 1 or vim.fn.executable("make") == 0 then
						return
					end
					return "make install_jsregexp"
				end)(),

				dependencies = {
					{
						"rafamadriz/friendly-snippets",
						config = function()
							require("luasnip.loaders.from_vscode").lazy_load()
						end,
					},
				},
			},

			{ "Bilal2453/luvit-meta", lazy = true },
			{
				"folke/lazydev.nvim",
				ft = "lua",
				opts = {
					library = {
						{ path = "luvit-meta/library", words = { "vim%.uv" } },
					},
				},
			},
			"dmitmel/cmp-cmdline-history",
			"saadparwaiz1/cmp_luasnip",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-cmdline",
			"Snikimonkd/cmp-go-pkgs",
			"onsails/lspkind.nvim",
		},

		config = function()
			local cmp = require("cmp")
			local luasnip = require("luasnip")
			local compare = require("cmp.config.compare")
			luasnip.config.setup({})

			-- https://github.com/hrsh7th/nvim-cmp/discussions/609#discussioncomment-5727678
			local formatting = {

				fields = {
					"abbr",
					-- "menu",
					"kind",
				},
				format = function(entry, item)
					local menu_icon = {
						nvim_lsp = "NLSP",
						nvim_lua = "NLUA",
						luasnip = "LSNP",
						buffer = "BUFF",
						path = "PATH",
					}
					item.menu = menu_icon[entry.source.name]
					local fixed_width = 60
					fixed_width = fixed_width or false
					local content = item.abbr

					if fixed_width then
						vim.o.pumwidth = fixed_width
					end

					local win_width = vim.api.nvim_win_get_width(0)
					local max_content_width = fixed_width and fixed_width - 10 or math.floor(win_width * 0.2)

					if
						#content > max_content_width
						and content:match("^diffget") == nil
						and content:match("^fugitive:///") == nil
					then
						item.abbr = vim.fn.strcharpart(content, 0, max_content_width - 3) .. "..."
					else
						item.abbr = content .. (" "):rep(max_content_width - #content)
					end

					return item
				end,
			}

			local buffer_source = {
				name = "buffer",
				keyword_length = 2,
				max_item_count = 5,
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

			cmp.setup({
				view = {
					entries = {
						vertical_positioning = "above",
					},
				},

				snippet = {
					expand = function(args)
						luasnip.lsp_expand(args.body)
					end,
				},
				mapping = cmp.mapping.preset.insert({
					["<C-n>"] = cmp.mapping.select_next_item(),
					["<C-p>"] = cmp.mapping.select_prev_item(),
					["<A-u>"] = cmp.mapping.scroll_docs(-4),
					["<A-d>"] = cmp.mapping.scroll_docs(4),
					["<C-y>"] = cmp.mapping.confirm({ select = true }),
					["<C-l>"] = cmp.mapping(function()
						luasnip.jump(1)
					end, { "i", "s" }),
					["<C-h>"] = cmp.mapping(function()
						luasnip.jump(-1)
					end, { "i", "s" }),
				}),

				sorting = {
					comparators = {
						compare.recently_used,
						compare.exact,
						compare.score,
						compare.locality,
						compare.offset,
						compare.kind,
						compare.sort_text,
						compare.length,
						compare.order,
					},
				},
				sources = {
					{ name = "go_pkgs", keyword_length = 2, priority = 1000 },
					{ name = "nvim_lsp", keyword_length = 2, max_item_count = 10 },
					{ name = "path", keyword_length = 3, max_item_count = 10 },
					buffer_source,
					{
						name = "luasnip",
						keyword_length = 2,
						option = { show_autosnippets = true },
						max_item_count = 10,
					},
					{ name = "lazydev", group_index = 0, max_item_count = 10 },
				},
				formatting = formatting,
				window = {
					completion = {
						winhighlight = "Normal:Normal,FloatBorder:FloatBorder,CursorLine:Visual,Search:None",
					},
					documentation = {
						winhighlight = "Normal:Normal,FloatBorder:FloatBorder,CursorLine:Visual,Search:None",
					},
				},

				matching = {
					disallow_symbol_nonprefix_matching = false,
				},
			})

			cmp.setup.cmdline({ ":", "?", "/" }, {
				mapping = cmp.mapping.preset.cmdline(),
				sources = cmp.config.sources({
					{ name = "cmdline_history", keyword_length = 2, max_item_count = 5 },
					{ name = "path", keyword_length = 3, max_item_count = 5 },
					{ name = "cmdline", keyword_length = 2, max_item_count = 5 },
					{ name = "lazydev", priority = 1001 },
					{ name = "nvim_lsp", priority = 1000, keyword_length = 2, max_item_count = 20 },
					buffer_source,
				}),
				comparators = {
					compare.recently_used,
					compare.exact,
					compare.score,
					compare.kind,
					compare.offset,
					compare.sort_text,
					compare.length,
					compare.order,
				},
				formatting = formatting,
				matching = { disallow_symbol_nonprefix_matching = false },
			})
		end,
	},
}
