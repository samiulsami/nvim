return {
	{ "kkharji/sqlite.lua" },

	{ "AndrewRadev/splitjoin.vim" },

	{
		"mbbill/undotree",
		config = function()
			vim.keymap.set("n", "<leader>u", ":UndotreeToggle<CR>", { desc = "Toggle UndoTree" })
		end,
	},

	{
		"szw/vim-maximizer",
		config = function()
			vim.keymap.set("n", "<M-CR>", ":MaximizerToggle<CR>", {})
		end,
	},

	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		-- Optional dependency
		dependencies = { "hrsh7th/nvim-cmp" },
		config = function()
			require("nvim-autopairs").setup({})
			-- If you want to automatically add `(` after selecting a function or method
			local cmp_autopairs = require("nvim-autopairs.completion.cmp")
			local cmp = require("cmp")
			cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
		end,
	},

	{
		-- `lazydev` configures Lua LSP for your Neovim config, runtime and plugins
		-- used for completion, annotations and signatures of Neovim apis
		"folke/lazydev.nvim",
		ft = "lua",
		opts = {
			library = {
				-- Load luvit types when the `vim.uv` word is found
				{ path = "luvit-meta/library", words = { "vim%.uv" } },
			},
		},
	},

	{
		"folke/todo-comments.nvim",
		event = "VimEnter",
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = { signs = false },
	},

	{
		"xiyaowong/nvim-transparent",
		config = function()
			require("transparent").setup({
				enable = true, -- Enable transparency
				extra_groups = { -- Specify groups to make transparent
					"Normal",
					"Comment",
					"Constant",
					"Identifier",
					"Function",
					"Statement",
					"PreProc",
					"Type",
					"Special",
					"Underlined",
					"Error",
					"Todo",
					"TelescopeNormal",
					"TelescopeBorder",
					"TelescopePromptNormal",
					"TelescopePromptBorder",
					"TelescopeResultsNormal",
					"TelescopeResultsBorder",
					"TelescopePreviewNormal",
					"TelescopePreviewBorder",
				},
				exclude_groups = {}, -- Optionally exclude groups here
			})
		end,
	},

	{
		"lukas-reineke/indent-blankline.nvim",
		config = function()
			require("ibl").setup()
		end,

		main = "ibl",
		---@module "ibl"
		---@type ibl.config
		opts = {},
	},
}
