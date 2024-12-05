return {
	{
		"folke/persistence.nvim",
		event = "VimEnter",
		priority = 998,
		config = function()
			require("persistence").setup({})

			vim.keymap.set("n", "<leader>qs", function()
				require("persistence").load()
			end, { desc = "Resume Directory [S]ession" })

			vim.keymap.set("n", "<leader>qS", function()
				require("persistence").select()
			end, { desc = "[S]elect Session" })

			vim.keymap.set("n", "<leader>ql", function()
				require("persistence").load({ last = true })
			end, { desc = "[Q]uickload [L]ast Session" })

			vim.keymap.set("n", "<leader>qd", function()
				require("persistence").stop()
			end, { desc = "Stop Persistence" })
		end,
	},
}
