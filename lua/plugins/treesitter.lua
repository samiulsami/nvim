return {
	{
		"nvim-treesitter/nvim-treesitter",
		dependencies = {
			"nvim-treesitter/nvim-treesitter-textobjects",
			"nvim-treesitter/nvim-treesitter-context",
		},
		build = ":TSUpdate",
		config = function()
			local configs = require("nvim-treesitter.configs")
			vim.filetype.add({
				extension = {
					gotmpl = "gotmpl",
				},
				pattern = {
					[".*/templates/.*%.tpl"] = "helm",
					[".*/templates/.*%.ya?ml"] = "helm",
					["helmfile.*%.ya?ml"] = "helm",
				},
			})
			configs.setup({
				ensure_installed = {
					"bash",
					"c",
					"cpp",
					"diff",
					"html",
					"lua",
					"luadoc",
					"markdown",
					"markdown_inline",
					"query",
					"vim",
					"vimdoc",
					"go",
					"latex",
					"gotmpl",
					"helm",
				},
				-- Autoinstall languages that are not installed
				--
				auto_install = true,
				highlight = {
					enable = true,
					additional_vim_regex_highlighting = { "ruby" },
				},
				indent = {
					enable = true,
					disable = { "ruby" },
				},
				folding = {
					enable = true,
					disable = {},
				},

				textobjects = {
					select = {
						enable = true,
						lookahead = true,
						keymaps = {
							["af"] = "@function.outer",
							["if"] = "@function.inner",
							["as"] = { query = "@local.scope", query_group = "locals", desc = "around scope" },
						},
					},
					move = {
						enable = true,
						set_jumps = true,
						goto_next_start = {
							["]f"] = "@function.outer",
							["]s"] = { query = "@local.scope", query_group = "locals" },
						},
						goto_next_end = {
							["]F"] = "@function.outer",
							["]S"] = { query = "@local.scope", query_group = "locals" },
						},
						goto_previous_start = {
							["[f"] = "@function.outer",
							["[s"] = { query = "@local.scope", query_group = "locals" },
						},
						goto_previous_end = {
							["[F"] = "@function.outer",
							["[S"] = { query = "@local.scope", query_group = "locals" },
						},
					},
				},
			})
			local treesitter_context = require("treesitter-context")

			vim.keymap.set("n", "<leader>tc", function()
				treesitter_context.toggle()
			end, { desc = "Toggle Treesitter Context" })

			treesitter_context.setup({
				enable = false, -- Enable this plugin (Can be enabled/disabled later via commands)
				multiwindow = false, -- Enable multiwindow support.
				max_lines = 0, -- How many lines the window should span. Values <= 0 mean no limit.
				min_window_height = 0, -- Minimum editor window height to enable context. Values <= 0 mean no limit.
				line_numbers = true,
				multiline_threshold = 20, -- Maximum number of lines to show for a single context
				trim_scope = "outer", -- Which context lines to discard if `max_lines` is exceeded. Choices: 'inner', 'outer'
				mode = "cursor", -- Line used to calculate context. Choices: 'cursor', 'topline'
				-- Separator between context and content. Should be a single character string, like '-'.
				-- When separator is set, the context will only show up when there are at least 2 lines above cursorline.
				separator = nil,
				zindex = 20, -- The Z-index of the context window
				on_attach = nil, -- (fun(buf: integer): boolean) return false to disable attaching
			})
		end,
	},
}
