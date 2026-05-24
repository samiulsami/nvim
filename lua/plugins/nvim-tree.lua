---@type PackSpec
return {
	src = "https://github.com/nvim-tree/nvim-tree.lua",
	config = function()
		---@type nvim_tree.config
		local config = {
			hijack_cursor = true,
			hijack_directories = {
				enable = true,
				auto_open = false,
			},
			update_focused_file = {
				enable = true,
				update_root = {
					enable = true,
				},
			},
			git = {
				enable = false,
			},
			sort = {
				sorter = "case_sensitive",
			},
			view = {
				width = 30,
				number = true,
				relativenumber = true,
			},
			renderer = {
				group_empty = true,
			},
			filters = {
				dotfiles = true,
				git_ignored = false,
			},
		}
		require("nvim-tree").setup(config)

		vim.keymap.set("n", "<A-p>", function()
			require("nvim-tree.api").tree.toggle({
				find_file = true,
				update_root = true,
				focus = true,
			})
		end, { desc = "Toggle nvim-tree" })
	end,
}
