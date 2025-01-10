return {
	{
		"davvid/harpoon",
		branch = "save-cursor-position",
		commit = "fcc21860d172e1352c2edce56176c3ab0ed53144",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-neo-tree/neo-tree.nvim",
		},
		config = function()
			local harpoon = require("harpoon")

			harpoon:setup({
				settings = {
					save_on_toggle = true,
					sync_on_ui_close = true,
					key_ = function()
						return vim.loop.cwd()
					end,
				},
			})

			vim.keymap.set("n", "<leader>a", function()
				harpoon:list():add()
				require("neo-tree.sources.manager").refresh("filesystem")
			end)

			vim.keymap.set("n", "<A-1>", function()
				harpoon:list():select(1)
				require("neo-tree.sources.manager").refresh("filesystem")
			end)
			vim.keymap.set("n", "<A-2>", function()
				harpoon:list():select(2)
				require("neo-tree.sources.manager").refresh("filesystem")
			end)
			vim.keymap.set("n", "<A-3>", function()
				harpoon:list():select(3)
				require("neo-tree.sources.manager").refresh("filesystem")
			end)
			vim.keymap.set("n", "<A-4>", function()
				harpoon:list():select(4)
				require("neo-tree.sources.manager").refresh("filesystem")
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
				require("neo-tree.sources.manager").refresh("filesystem")
			end)
		end,
	},
}
