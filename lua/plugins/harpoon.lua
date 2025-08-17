return {
	{
		"ThePrimeagen/harpoon",
		branch = "harpoon2",
		-- commit = "fcc21860d172e1352c2edce56176c3ab0ed53144",
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		config = function()
			local harpoon = require("harpoon")

			harpoon:setup({
				settings = {
					save_on_toggle = true,
					sync_on_ui_close = true,
					key_ = function()
						return vim.uv.cwd()
					end,
				},
			})

			vim.keymap.set("n", "<leader>a", function()
				harpoon:list():add()
			end)

			vim.keymap.set("n", "<A-q>", function()
				harpoon:list():select(1)
			end)
			vim.keymap.set("n", "<A-w>", function()
				harpoon:list():select(2)
			end)
			vim.keymap.set("n", "<A-e>", function()
				harpoon:list():select(3)
			end)
			vim.keymap.set("n", "<A-r>", function()
				harpoon:list():select(4)
			end)

			vim.keymap.set("n", "<A-t>", function()
				harpoon.ui:toggle_quick_menu(harpoon:list())
			end)
		end,
	},
}
