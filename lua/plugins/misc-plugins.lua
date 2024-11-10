return {
	{
		"folke/zen-mode.nvim",
		dependencies = {
			"lewis6991/gitsigns.nvim",
		},
		event = "VeryLazy",
		config = function()
			vim.keymap.set("n", "<leader>z", require("zen-mode").toggle, { desc = "Toggle Zen Mode" })
		end,
	},

	{ "AndrewRadev/splitjoin.vim" },

	{
		"mbbill/undotree",
		config = function()
			vim.keymap.set("n", "<leader>u", ":UndotreeToggle<CR>", { desc = "Toggle UndoTree" })
		end,
	},

	{
		"anuvyklack/windows.nvim",
		dependencies = {
			"anuvyklack/middleclass",
		},
		config = function()
			require("windows").setup({
				autowidth = {
					enable = false,
				},
				ignore = {},
				animation = {
					enable = false,
				},
			})

			vim.keymap.set("n", "<M-CR>", ":WindowsMaximize<CR>", { desc = "Toggle Windows" })
			vim.keymap.set("n", "<C-w>_", ":WindowsMaximizeVertically<CR>", { desc = "Vertically Maximize Windows" })
			vim.keymap.set(
				"n",
				"<c-w>|",
				":WindowsMaximizeHorizontally<CR>",
				{ desc = "Horizontally Maximize Windows" }
			)
			vim.keymap.set("n", "<c-w>=", ":WindowsEqualize<CR>", { desc = "Equalize Windows" })
		end,
	},
	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		dependencies = { "hrsh7th/nvim-cmp" },
		config = function()
			require("nvim-autopairs").setup({})
			local cmp_autopairs = require("nvim-autopairs.completion.cmp")
			local cmp = require("cmp")
			cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
		end,
	},

	{
		"folke/lazydev.nvim",
		ft = "lua",
		opts = {
			library = {
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
