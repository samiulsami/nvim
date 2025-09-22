return {
	{
		"nvim-treesitter/nvim-treesitter",
		dependencies = {
			"nvim-treesitter/nvim-treesitter-textobjects",
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
							["ac"] = "@class.outer",
							["ic"] = "@class.inner",
							["al"] = "@loop.outer",
							["il"] = "@loop.inner",
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
		end,
	},
}
