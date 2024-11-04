return {
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		config = function()
			local configs = require("nvim-treesitter.configs")

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
			})
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter-context",
		dependencies = { "nvim-treesitter/nvim-treesitter" }, -- Ensure nvim-treesitter is loaded
		config = function()
			vim.api.nvim_set_hl(0, "TreesitterContext", { bg = "NONE" })
			vim.api.nvim_set_hl(0, "TreesitterContextLineNumber", { bg = "NONE" })

			-- You can add additional setup options here if needed
			require("treesitter-context").setup({
				-- Options for the context setup
			})

			require("treesitter-context").setup({
				enable = true, -- Enable this plugin (can be toggled on/off)
				max_lines = 3, -- How many lines the context window should show
				trim_scope = "outer", -- Remove lines from outer context when exceeded
				min_window_height = 0, -- Only show context if the window is larger than this value
				mode = "cursor", -- Line used to calculate context ('cursor' or 'topline')
				separator = "-", -- Separator for the context line
				zindex = 20, -- The Z-index of the context window
				on_attach = nil, -- Callback when context is attached to buffer
			})
		end,
	},
}
