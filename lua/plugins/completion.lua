return {
	{ "charlespascoe/vim-go-syntax" },
	{ -- Autocompletion
		"hrsh7th/nvim-cmp",
		event = { "InsertEnter", "CmdlineEnter" },
		dependencies = {
			{
				"L3MON4D3/LuaSnip",
				build = (function()
					-- Build Step is needed for regex support in snippets.
					-- This step is not supported in many windows environments.
					-- Remove the below condition to re-enable on windows.
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
			"tzachar/cmp-fuzzy-buffer",
			"tzachar/fuzzy.nvim",
			"saadparwaiz1/cmp_luasnip",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-cmdline",
			"hrsh7th/cmp-nvim-lsp-signature-help",
			"hrsh7th/cmp-nvim-lsp-document-symbol",
			"Snikimonkd/cmp-go-pkgs",
			"onsails/lspkind.nvim",
			"rcarriga/cmp-dap",
			"hrsh7th/cmp-omni",
			"ray-x/cmp-treesitter",
			{
				"lukas-reineke/cmp-rg",
				lazy = true,
				enabled = function()
					return vim.fn.executable("rg") == 1
				end,
			},
			{
				"Exafunction/codeium.vim",
				lazy = true,
				event = "BufEnter",
				config = function()
					vim.keymap.set("i", "<c-g>", function()
						return vim.fn["codeium#Accept"]()
					end, { expr = true, silent = true })

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
					-- Select the [n]ext item
					["<C-n>"] = cmp.mapping.select_next_item(),
					-- Select the [p]revious item
					["<C-p>"] = cmp.mapping.select_prev_item(),

					-- Scroll the documentation window [b]ack / [f]orward
					["<C-b>"] = cmp.mapping.scroll_docs(-4),
					["<C-f>"] = cmp.mapping.scroll_docs(4),

					-- Accept ([y]es) the completion.
					--  This will auto-import if your LSP supports it.
					--  This will expand snippets if the LSP sent a snippet.
					["<C-y>"] = cmp.mapping.confirm({ select = true }),

					-- If you prefer more traditional completion keymaps,
					-- you can uncomment the following lines
					--['<CR>'] = cmp.mapping.confirm { select = true },
					--['<Tab>'] = cmp.mapping.select_next_item(),
					--['<S-Tab>'] = cmp.mapping.select_prev_item(),
					--  completions whenever it has completion options available.
					["<C-Space>"] = cmp.mapping.complete({}),

					-- Think of <c-l> as moving to the right of your snippet expansion.
					--  So if you have a snippet that's like:
					--  function $name($args)
					--    $body
					--  end
					--
					-- <alt-l> will move you to the right of each of the expansion locations.
					-- <alt-h> is similar, except moving you backwards.
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

					-- For more advanced Luasnip keymaps (e.g. selecting choice nodes, expansion) see:
					--    https://github.com/L3MON4D3/LuaSnip?tab=readme-ov-file#keymaps
				}),
				sources = {
					{
						name = "rg",
						keyword_length = 5,
						max_item_count = 5,
						option = {
							additional_arguments = "--smart-case --hidden",
						},
						priority = 80,
						group_index = 3,
					},
					{
						name = "dap",
						priority = 40,
						group_index = 6,
						max_item_count = 5,
					},
					{
						name = "nvim_lsp_signature_help",
						priority = 100,
						group_index = 1,
						max_item_count = 5,
					},
					{
						name = "treesitter",
						max_item_count = 5,
						priority = 90,
						group_index = 5,
						entry_filter = function(entry, vim_item)
							if entry.kind == 15 then
								local cursor_pos = vim.api.nvim_win_get_cursor(0)
								local line = vim.api.nvim_get_current_line()
								local next_char = line:sub(cursor_pos[2] + 1, cursor_pos[2] + 1)
								if next_char == '"' or next_char == "'" then
									vim_item.abbr = vim_item.abbr:sub(1, -2)
								end
							end
							return vim_item
						end,
					},
					{ name = "nvim_lsp_document_symbol", max_item_count = 5 },
					{ name = "dap", max_item_count = 5 },
					{
						name = "lazydev",
						-- set group index to 0 to skip loading LuaLS completions as lazydev recommends it
						group_index = 0,
					},
					{
						name = "nvim_lsp",
						max_item_count = 5,
						option = {
							go = {
								keyword_pattern = [[\%([A-Za-z_]\k*\)]],
							},
						},
					},
					{ name = "luasnip" },
					{
						name = "omni",
						max_item_count = 5,
						option = {
							disable_omnifuncs = { "v:lua.vim.lsp.omnifunc" },
						},
					},
					{ name = "path", max_item_count = 5 },
					{ name = "buffer", max_item_count = 5 },
					{ name = "fuzzy_buffer", max_item_count = 5 },
					{ name = "go_pkgs", max_item_count = 5 },
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
			})

			cmp.setup.cmdline(":", {
				mapping = cmp.mapping.preset.cmdline(),
				sources = cmp.config.sources({
					{ name = "path" },
				}, {
					{ name = "cmdline" },
				}),
				matching = { disallow_symbol_nonprefix_matching = false },
			})
		end,
	},
}
