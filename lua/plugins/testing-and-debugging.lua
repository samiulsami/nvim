return {
	{
		"rcarriga/nvim-dap-ui",
		dependencies = {
			"nvim-neotest/nvim-nio",
			"mfussenegger/nvim-dap",
		},
	},

	{
		"nvim-neotest/neotest",
		dependencies = {

			"nvim-neotest/nvim-nio",
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
			"antoinemadec/FixCursorHold.nvim", -- Improves responsiveness
			{
				"fredrikaverpil/neotest-golang",
				dependencies = {
					"leoluz/nvim-dap-go",
				},
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

			vim.keymap.set("n", "<leader>td", function()
				neotest.run.run({ suite = false, strategy = "dap" })
			end, { noremap = true, silent = true, desc = "Debug nearest test" })

			vim.keymap.set("n", "<leader>ts", function()
				neotest.summary.toggle()
			end, { noremap = true, desc = "Toggle sumary" })

			vim.keymap.set("n", "<leader>to", function()
				neotest.output_panel.toggle()
			end, { noremap = true, desc = "Toggle output panel" })
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

			dap.adapters.codelldb = {
				type = "server",
				port = 13000,
				executable = {
					command = vim.fn.expand("~/.local/share/nvim/mason/packages/codelldb/codelldb"),
					args = { "--port", "13000" },
				},
			}

			dap.configurations.cpp = {
				{
					name = "Launch C++ executable",
					type = "codelldb",
					request = "launch",
					program = function()
						return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
					end,
					cwd = "${workspaceFolder}",
					stopAtEntry = false,
					runInTerminal = false,
				},
			}

			vim.keymap.set("n", "<leader>b", dap.toggle_breakpoint)
			vim.keymap.set("n", "<leader>rc", dap.run_to_cursor)
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
			vim.keymap.set("n", "<F13>", dap.restart)

			dap.listeners.before.attach.dapui_config = function()
				ui.open()
			end
			dap.listeners.before.launch.dapui_config = function()
				ui.open()
			end
			dap.listeners.before.event_terminated.dapui_config = function()
				ui.close()
			end
			dap.listeners.before.event_exited.dapui_config = function()
				ui.close()
			end
		end,
	},
}
