return {
	{
		"folke/snacks.nvim",
		priority = 500000,
		lazy = false,

		config = function()
			local opts = {
				-- your configuration comes here
				-- or leave it empty to use the default settings
				-- refer to the configuration section below
				bigfile = {

					enabled = true,
					size = 50 * 1024 * 1024, -- 50 MB
				},
				dashboard = {
					enabled = true,
					sections = {
						{ section = "header" },
						{ icon = " ", title = "Keymaps", section = "keys", indent = 2, padding = 1 },
						{ icon = " ", title = "Projects", section = "projects", indent = 2, padding = 1 },
						{ icon = " ", title = "Recent Files", section = "recent_files", indent = 2, padding = 1 },
						{ section = "startup" },
					},
				},
				indent = {
					enabled = true,
					animate = {
						enabled = false,
					},
				},
				input = { enabled = true },
				quickfile = { enabled = true },
				statuscolumn = { enabled = true },
			}

			local Snacks = require("snacks")
			Snacks.setup(opts)

			vim.keymap.set("n", "<leader>gp", function()
				Snacks.gitbrowse()
			end, { desc = "[G]ithub [P]review" })

			vim.keymap.set("n", "<leader>db", function()
				Snacks.dashboard()
			end, { desc = "[D]ash[B]oard" })
		end,
	},
}
