return	{
	{
		"nvim-neotest/neotest",
		dependencies = {
			"nvim-neotest/nvim-nio",
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
			"antoinemadec/FixCursorHold.nvim", -- Improves responsiveness
			"nvim-neotest/neotest-go", -- Go adapter
		},
		config = function()
			local neotest = require("neotest")
			neotest.setup({
				adapters = {
					require("neotest-go")({}),
				},
			})

			-- Add keymaps for running tests
			vim.keymap.set("n", "<leader>tx", function()
				require("neotest").run.stop({ strategy = "all", interactive = true })
			end, { desc = "Stop all Neotest tests" })
			vim.api.nvim_set_keymap(
				"n",
				"<leader>tt",
				"<cmd>lua require('neotest').run.run()<CR>",
				{ noremap = true, desc = "Run nearest test" }
			)
			vim.api.nvim_set_keymap(
				"n",
				"<leader>tf",
				"<cmd>lua require('neotest').run.run(vim.fn.expand('%'))<CR>",
				{ noremap = true, desc = "Run all tests in file" }
			)
			vim.api.nvim_set_keymap(
				"n",
				"<leader>ta",
				'<cmd>lua require("neotest").run.run({strategy = "dap"})<CR>',
				{ noremap = true, silent = true, desc = "Run all tests" }
			)
			vim.api.nvim_set_keymap(
				"n",
				"<leader>ts",
				"<cmd>lua require('neotest').summary.toggle()<CR>",
				{ noremap = true, desc = "Toggle sumary" }
			)
			vim.api.nvim_set_keymap(
				"n",
				"<leader>to",
				"<cmd>lua require('neotest').output_panel.toggle()<CR>",
				{ noremap = true, desc = "Toggle output panel" }
			)
		end,
	},
    {
		"mfussenegger/nvim-dap",
		dependencies = {
			"leoluz/nvim-dap-go",
			"rcarriga/nvim-dap-ui",
			"nvim-neotest/nvim-nio",
			"williamboman/mason.nvim",
		},
		config = function()
			local dap = require("dap")
			local ui = require("dapui")

			require("dapui").setup()
			require("dap-go").setup()

			vim.keymap.set("n", "<leader>b", dap.toggle_breakpoint)
			vim.keymap.set("n", "<leader>rc", dap.run_to_cursor)

			-- Set up your key mapping for evaluating an expression
			vim.keymap.set("n", "<leader>?", function()
				ui.eval(nil, { context = "hover", enter = true, width = 50, height = 10 })
			end)

			vim.keymap.set("n", "<leader>dus", function()
				local widgets = require("dap.ui.widgets")
				local sidebar = widgets.sidebar(widgets.scopes)
				sidebar.open()
			end, { desc = "Open debugging sidebar" })

			vim.keymap.set("n", "<F1>", dap.continue)
			vim.keymap.set("n", "<F2>", dap.step_into)
			vim.keymap.set("n", "<F3>", dap.step_over)
			vim.keymap.set("n", "<F4>", dap.step_out)
			vim.keymap.set("n", "<F5>", dap.step_back)
			vim.keymap.set("n", "<F6>", function()
				require("dap").terminate()
				require("dapui").close()
			end, { desc = "Stop debugging session" })

			vim.keymap.set("n", "<leader>dus", function()
				local widgets = require("dap.ui.widgets")
				local sidebar = widgets.sidebar(widgets.scopes)
				sidebar.open()
			end, { desc = "Open debugging sidebar" })

			vim.keymap.set("n", "<F13>", dap.restart)

			-- dap.listeners.before.attach.dapui_config = function()
			--   ui.open()
			-- end
			-- dap.listeners.before.launch.dapui_config = function()
			--   ui.open()
			-- end
			-- dap.listeners.before.event_terminated.dapui_config = function()
			--   ui.close()
			-- end
			-- dap.listeners.before.event_exited.dapui_config = function()
			--   ui.close()
			-- end
		end,
	},

}
