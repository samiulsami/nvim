return {
	{
		"folke/snacks.nvim",
		priority = 500000,
		lazy = false,
		--stylua: ignore
		---@type snacks.Config
		opts = {
			bigfile = { enabled = true, size = 10 * 1024 * 1024 },
			indent = { enabled = true, animate = { enabled = false } },
			input = { enabled = false },
			quickfile = { enabled = true },
			statuscolumn = { enabled = true },
			words = { enabled = true, debounce = 50 },
			scratch = { enabled = true },
			picker = { enabled = true },
			notifier = { enabled = true, timeout = 1500 },
			explorer = { enabled = true },
		},
		--stylua: ignore
		keys = {
			{ "<leader>gp", function() Snacks.gitbrowse() end, { desc = "[G]ithub [P]review" } },
			{ "<leader>.", function() Snacks.scratch() end, { desc = "Toggle Scratch Buffer" } },
			{ "<leader>S", function() Snacks.scratch.select() end, { desc = "Toggle Scratch Buffer" } },
		},
	},
}
