return {
	{
		"mfussenegger/nvim-dap",
		dependencies = {
			"leoluz/nvim-dap-go",
			"miroshQa/debugmaster.nvim",
		},
		config = function()
			local dap_go = require("dap-go")
			dap_go.setup()
			vim.keymap.set("n", "<leader>dg", function()
				dap_go.debug_test()
			end, { desc = "[D]ebug the nearest [G]o test above cursor" })

			local dm = require("debugmaster")
			vim.keymap.set({ "n", "v" }, "<leader>D", dm.mode.toggle, { nowait = true, desc = "[D]ebug Master" })
		end,
	},
}
