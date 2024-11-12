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
			"saadparwaiz1/cmp_luasnip",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-cmdline",
			"Snikimonkd/cmp-go-pkgs",
			"onsails/lspkind.nvim",

			{
				"supermaven-inc/supermaven-nvim",
				config = function()
					require("supermaven-nvim").setup({
						keymaps = {
							accept_suggestion = "<c-j>",
							clear_suggestion = "<c-]>",
							accept_word = "<A-k>",
						},
						log_level = "info",
					})
				end,
			},
		},

		config = function()
			local cmp = require("cmp")
			local luasnip = require("luasnip")
			local compare = require("cmp.config.compare")
			luasnip.config.setup({})

			local buffer_source = {
				name = "buffer",
				priority = 5,
				max_item_count = 10,
				option = {
					get_bufnrs = function()
						local buf = vim.api.nvim_get_current_buf()
						local byte_size = vim.api.nvim_buf_get_offset(buf, vim.api.nvim_buf_line_count(buf))
						if byte_size > 1024 * 512 then -- 512kb MAX
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
					["<C-Space>"] = cmp.mapping.complete({}),
					["<A-l>"] = cmp.mapping(function()
						if luasnip.expand_or_locally_jumpable() then
							luasnip.expand_or_jump()
						end
					end, { "i", "s" }),
					["<A-h>"] = cmp.mapping(function()
						if luasnip.locally_jumpable(-1) then
							luasnip.jump(-1)
						end
					end, { "i", "s" }),
				}),
				sources = {

					{
						name = "go_pkgs",
						priority = 150,
					},

					{
						name = "nvim_lsp",
						priority = 100,
					},

					{
						name = "path",
						priority = 10,
					},

					buffer_source,

					{
						name = "luasnip",
						priority = 1,
					},

					{
						name = "lazydev",
						group_index = 0,
					},
				},
				sorting = {
					comparators = {
						function(...)
							return require("cmp_buffer"):compare_locality(...)
						end,
						compare.offset,
						compare.exact,
						compare.score,
						compare.recently_used,
						compare.locality,
						compare.kind,
						compare.sort_text,
						compare.length,
						compare.order,
					},
				},
				formatting = {
					format = require("lspkind").cmp_format({
						with_text = true,
						menu = {
							go_pkgs = "[pkgs]",
						},
					}),
				},
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

			cmp.setup.cmdline({ "/", "?" }, {
				mapping = cmp.mapping.preset.cmdline(),
				sources = {
					buffer_source,
				},
			})

			cmp.setup.cmdline(":", {
				mapping = cmp.mapping.preset.cmdline(),
				sources = cmp.config.sources({
					{
						name = "path",
					},

					{
						name = "cmdline",
					},

					{
						name = "lazydev",
					},

					buffer_source,
				}),
				matching = { disallow_symbol_nonprefix_matching = false },
			})
		end,
	},
}
