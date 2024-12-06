return {
	{
		"ThePrimeagen/harpoon",
		branch = "harpoon2",
		commit = "e76cb03c420bb74a5900a5b3e1dde776156af45f",
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		config = function()
			local harpoon = require("harpoon")

			harpoon:setup({
				settings = {
					save_on_toggle = true,
					save_on_close = true,
					key_ = function()
						return vim.loop.cwd()
					end,
				},
			})

			vim.keymap.set("n", "<leader>a", function()
				harpoon:list():add()
			end)

			vim.keymap.set("n", "<A-1>", function()
				harpoon:list():select(1)
			end)
			vim.keymap.set("n", "<A-2>", function()
				harpoon:list():select(2)
			end)
			vim.keymap.set("n", "<A-3>", function()
				harpoon:list():select(3)
			end)
			vim.keymap.set("n", "<A-4>", function()
				harpoon:list():select(4)
			end)

			-- Toggle previous & next buffers stored within Harpoon list
			vim.keymap.set("n", "<C-S-P>", function()
				harpoon:list():prev()
			end)
			vim.keymap.set("n", "<C-S-N>", function()
				harpoon:list():next()
			end)

			vim.keymap.set("n", "<A-e>", function()
				harpoon.ui:toggle_quick_menu(harpoon:list())
			end)
		end,
	},
}
