return {

	{
		"nvim-neotest/neotest",
		dependencies = {

			"nvim-neotest/nvim-nio",
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
			{
				"fredrikaverpil/neotest-golang",
			},
		},
		config = function()
			local neotest = require("neotest")
			neotest.setup({
				discovery = {
					enabled = false,
					concurent = 1,
				},

				running = {
					concurrent = true,
				},
				summary = {
					animated = false,
				},
				adapters = {
					require("neotest-golang")({}),
				},
			})

			-- Add keymaps for running tests
			vim.keymap.set("n", "<leader>tx", function()
				neotest.run.stop({ strategy = "all", interactive = true })
			end, { desc = "Stop all Neotest tests" })

			vim.keymap.set("n", "<leader>tt", function()
				neotest.run.run()
			end, { noremap = true, desc = "Run nearest test" })

			vim.keymap.set("n", "<leader>tf", function()
				neotest.run.run(vim.fn.expand("%"))
			end, { noremap = true, desc = "Run all tests in file" })

			vim.keymap.set("n", "<leader>ts", function()
				neotest.summary.toggle()
			end, { noremap = true, desc = "Toggle sumary" })

			vim.keymap.set("n", "<leader>to", function()
				neotest.output_panel.toggle()
			end, { noremap = true, desc = "Toggle output panel" })
		end,
	},
}
