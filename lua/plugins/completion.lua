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

			"saadparwaiz1/cmp_luasnip",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-cmdline",
			"Snikimonkd/cmp-go-pkgs",
			"onsails/lspkind.nvim",

			{
				"Exafunction/codeium.vim",
				lazy = true,
				event = "BufEnter",
				config = function()
					vim.keymap.set("i", "<c-g>", function()
						return vim.fn["codeium#Accept"]()
					end, { expr = true, silent = true })
					vim.keymap.set(
						"n",
						"<leader>tc",
						":CodeiumToggle<CR>",
						{ noremap = true, silent = true, desc = "[T]oggle [C]odeium" }
					)

					vim.g.codeium_disable_bindings = 1
					vim.g.codeium_filetypes = {
						TelescopePrompt = false,
						NvimTree = false,
						dapui_scopes = false,
						dapui_breakpoints = false,
						dapui_stacks = false,
						dapui_repl = false,
						dapui_console = false,
						dapui_watches = false,
						dressing = false,
						fugitive = false,
						gitcommit = false,
						gitrebase = false,
						gitsigns = false,
						help = false,
					}
				end,
			},
		},

		config = function()
			local cmp = require("cmp")
			local luasnip = require("luasnip")
			luasnip.config.setup({})

			cmp.setup({
				snippet = {
					expand = function(args)
						luasnip.lsp_expand(args.body)
					end,
				},

				-- For an understanding of why these mappings were
				-- chosen, you will need to read `:help ins-completion`
				-- No, but seriously. Please read `:help ins-completion`, it is really good!
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
						name = "lazydev",
						group_index = 0,
					},
					{ name = "nvim_lsp", max_item_count = 10 },
					{ name = "luasnip", max_item_count = 10 },
					{ name = "path", max_item_count = 10 },
					{ name = "buffer", max_item_count = 10 },
					{
						name = "go_pkgs",
						max_item_count = 100,
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
						-- other completion window options...
					},
					documentation = {
						winhighlight = "Normal:Normal,FloatBorder:FloatBorder,CursorLine:Visual,Search:None",
						-- other documentation window options...
					},
				},
				matching = {
					disallow_symbol_nonprefix_matching = false,
					disallow_fuzzy_matching = false,
					disallow_fullfuzzy_matching = false,
					disallow_partial_fuzzy_matching = false,
					disallow_partial_matching = false,
					disallow_prefix_unmatching = false,
					only_sorting_matching = false,
				},
			})

			cmp.setup.cmdline(":", {
				mapping = cmp.mapping.preset.cmdline(),
				sources = cmp.config.sources({
					{ name = "path", max_item_count = 5 },
				}, {
					{ name = "cmdline", max_item_count = 5 },
				}),
				matching = { disallow_symbol_nonprefix_matching = false },
			})
		end,
	},
}
