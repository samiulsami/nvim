return {
	{
		"nvim-tree/nvim-tree.lua",
		requires = { "nvim-tree/nvim-web-devicons" }, -- For file icons
		config = function()
			vim.g.nvim_tree_respect_buf_cwd = 0
			vim.api.nvim_set_keymap("n", "<leader>e", ":NvimTreeToggle<CR>", { noremap = true, silent = true })
			require("nvim-tree").setup({
				update_focused_file = {
					enable = true,
					update_root = false,
				},
				-- Disable netrw, it conflicts with nvim-tree
				disable_netrw = true,
				hijack_netrw = true,

				actions = {
					open_file = {
						window_picker = {
							enable = false,
						},
					},
				},
				-- View settings
				view = {
					width = 30, -- Width of the tree
					side = "left", -- Positioning of the tree
					adaptive_size = true, -- Do not auto-resize the tree
					signcolumn = "yes", -- Show signcolumn
					number = true, -- Show line numbers
					relativenumber = true, -- Use relative line numbers if you want
				},

				-- Add icons to the tree
				renderer = {
					highlight_git = true, -- Highlight Git status
					icons = {
						show = {
							file = true,
							folder = true,
							folder_arrow = true,
							git = true,
						},
					},
				},

				-- Git integration settings
				git = {
					enable = true,
					ignore = false,
				},

				-- Filters
				filters = {
					dotfiles = false, -- Show dotfiles
					custom = { ".git", "node_modules" }, -- Hide .git and node_modules
				},
			})
		end,
	},
}
