return {
	{
		"hrsh7th/nvim-cmp",
		event = { "InsertEnter", "CmdlineEnter" },
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
			{
				"petertriho/cmp-git",
				config = function()
					require("cmp_git").setup()
				end,
			},
			"onsails/lspkind.nvim",
		},

		config = function()
			local cmp = require("cmp")
			local luasnip = require("luasnip")
			local compare = require("cmp.config.compare")
			luasnip.config.setup({})

			-- https://github.com/hrsh7th/nvim-cmp/discussions/609#discussioncomment-5727678
			formatting = {
				fields = {
					"abbr",
					-- "menu",
					"kind",
				},
				format = function(entry, item)
					-- Define menu shorthand for different completion sources.
					-- local menu_icon = {
					-- 	nvim_lsp = "NLSP",
					-- 	nvim_lua = "NLUA",
					-- 	luasnip = "LSNP",
					-- 	buffer = "BUFF",
					-- 	path = "PATH",
					-- }
					-- -- Set the menu "icon" to the shorthand for each completion source.
					-- item.menu = menu_icon[entry.source.name]

					-- Set the fixed width of the completion menu to 60 characters.
					local fixed_width = 60

					-- Set 'fixed_width' to false if not provided.
					fixed_width = fixed_width or false

					-- Get the completion entry text shown in the completion window.
					local content = item.abbr

					-- Set the fixed completion window width.
					if fixed_width then
						vim.o.pumwidth = fixed_width
					end

					-- Get the width of the current window.
					local win_width = vim.api.nvim_win_get_width(0)

					-- Set the max content width based on either: 'fixed_width'
					-- or a percentage of the window width, in this case 20%.
					-- We subtract 10 from 'fixed_width' to leave room for 'kind' fields.
					local max_content_width = fixed_width and fixed_width - 10 or math.floor(win_width * 0.2)

					-- Truncate the completion entry text if it's longer than the
					-- max content width. We subtract 3 from the max content width
					-- to account for the "..." that will be appended to it.
					if #content > max_content_width then
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
				snippet = {
					expand = function(args)
						luasnip.lsp_expand(args.body)
					end,
				},

				mapping = cmp.mapping.preset.insert({
					["<C-n>"] = cmp.mapping.select_next_item(),
					["<C-p>"] = cmp.mapping.select_prev_item(),
					["<C-b>"] = cmp.mapping.scroll_docs(-4),
					["<C-f>"] = cmp.mapping.scroll_docs(4),
					["<C-y>"] = cmp.mapping.confirm({ select = true }),
					["<C-L>"] = cmp.mapping(function()
						if luasnip.locally_jumpable(-1) then
							luasnip.jump(1)
						end
					end, { "i", "s" }),
				}),
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
				sorting = {
					comparators = {
						function(...)
							return require("cmp_buffer"):compare_locality(...)
						end,
						compare.exact,
						compare.score,
						compare.recently_used,
						compare.locality,
						compare.offset,
						compare.kind,
						compare.sort_text,
						compare.length,
						compare.order,
					},
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
					{ name = "lazydev" },
					{ name = "git", max_item_count = 5 },
					{ name = "nvim_lsp", keyword_length = 2, max_item_count = 20 },
					buffer_source,
				}),
				formatting = formatting,
				matching = { disallow_symbol_nonprefix_matching = false },
			})
		end,
	},
}
