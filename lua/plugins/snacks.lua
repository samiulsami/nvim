return {
	{
		"folke/snacks.nvim",
		priority = 500000,
		lazy = false,

		config = function()
			local opts = {
				bigfile = {
					enabled = true,
					size = 10 * 1024 * 1024, -- 10 MB
				},
				indent = {
					enabled = true,
					animate = { enabled = false },
				},
				input = { enabled = true },
				quickfile = { enabled = true },
				statuscolumn = { enabled = true },
				words = {
					enabled = true,
					debounce = 50,
				},
				scratch = {
					enabled = true,
				},
			}

			local Snacks = require("snacks")
			Snacks.setup(opts)

			vim.keymap.set("n", "<leader>gp", function()
				Snacks.gitbrowse()
			end, { desc = "[G]ithub [P]review" })

			vim.keymap.set("n", "<leader>.", function()
				Snacks.scratch()
			end, { desc = "Toggle Scratch Buffer" })

			vim.keymap.set("n", "<leader>S", function()
				Snacks.scratch.select()
			end, { desc = "Toggle Scratch Buffer" })
		end,
	},
}
