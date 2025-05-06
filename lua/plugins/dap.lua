return {
	{
		"mfussenegger/nvim-dap",
		dependencies = {
			"nvim-neotest/nvim-nio",
			"williamboman/mason.nvim",
		},
		config = function()
			local dap = require("dap")

			vim.keymap.set("n", "<leader>b", dap.toggle_breakpoint)
			vim.keymap.set("n", "<leader>rc", dap.run_to_cursor)
		end,
	},

	{
		"leoluz/nvim-dap-go",
		config = function()
			local dap_go = require("dap-go")
			dap_go.setup()

			vim.keymap.set("n", "<leader>dg", function()
				dap_go.debug_test()
			end, { desc = "[D]ebug the nearest [G]o test above cursor" })
		end,
	},

	{
		"miroshQa/debugmaster.nvim",
		config = function()
			local dm = require("debugmaster")
			vim.keymap.set({ "n", "v" }, "<leader>D", dm.mode.toggle, { nowait = true })
		end,
	},
}
