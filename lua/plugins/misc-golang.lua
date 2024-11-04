return {
	{ "charlespascoe/vim-go-syntax" },
	{
		"olexsmir/gopher.nvim",
		ft = "go",
		-- branch = "develop", -- if you want develop branch
		-- keep in mind, it might break everything
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
			"mfussenegger/nvim-dap", -- (optional) only if you use `gopher.dap`
		},
		-- (optional) will update plugin's deps on every update
		config = function()
			require("gopher").setup({
				commands = {
					go = "go",
					gomodifytags = "gomodifytags",
					gotests = "gotests",
					impl = "impl",
					iferr = "iferr",
					dlv = "dlv",
				},
				gotests = {
					-- gotests doesn't have template named "default" so this plugin uses "default" to set the default template
					template = "default",
					-- path to a directory containing custom test code templates
					template_dir = nil,
					-- switch table tests from using slice to map (with test name for the key)
					-- works only with gotests installed from develop branch
					named = false,
				},
				gotag = {
					transform = "camelcase",
				},
			})

			vim.keymap.set(
				"n",
				"<leader>gtj",
				":GoTagAdd json<CR>",
				{ noremap = true, silent = true, desc = "Add json tags" }
			)
			vim.keymap.set(
				"n",
				"<leader>gty",
				":GoTagAdd yaml<CR>",
				{ noremap = true, silent = true, desc = "Add yaml tags" }
			)

			vim.keymap.set(
				"n",
				"<leader>gtrj",
				":GoTagRm json<CR>",
				{ noremap = true, silent = true, desc = "Add json tags" }
			)
			vim.keymap.set(
				"n",
				"<leader>gtry",
				":GoTagRm yaml<CR>",
				{ noremap = true, silent = true, desc = "Add yaml tags" }
			)
			vim.keymap.set(
				"n",
				"<leader>gto",
				":GoTestAdd<CR>",
				{ noremap = true, silent = true, desc = "Add test for function under curson" }
			)
			vim.keymap.set(
				"n",
				"<leader>gta",
				":GoTestAll<CR>",
				{ noremap = true, silent = true, desc = "Add tests for all funcs in file" }
			)
			vim.keymap.set(
				"n",
				"<leader>gte",
				":GoTestAll<CR>",
				{ noremap = true, silent = true, desc = "Add tests for all exported funcs in file" }
			)
		end,
		---@type gopher.Config
		opts = {},
	},
}
