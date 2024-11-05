return {
	{
		"tpope/vim-fugitive",
		config = function()
			vim.keymap.set("n", "<leader>gs", ":Git<CR>", {})
			vim.keymap.set("n", "<leader>gd", ":Gvdiffsplit<CR>", { desc = "Git Diff Split" })
			vim.keymap.set("n", "<leader>gb", ":Git blame<CR>", { desc = "Git Blame" })
		end,
	},

	{
		"lewis6991/gitsigns.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim", -- Required dependency
		},
		config = function()
			require("gitsigns").setup({
				signs = {
					add = { text = "┃" }, -- Sign for added lines
					change = { text = "┃" }, -- Sign for changed lines
					delete = { text = "✖" }, -- Sign for deleted lines
					topdelete = { text = "✖" }, -- Sign for deleted lines at the top
					changedelete = { text = "≃" }, -- Sign for changed lines that were deleted
				},
				numhl = true, -- Highlight line numbers
				linehl = false, -- Highlight the entire line
				word_diff = false, -- Enable word diff for inline changes
				current_line_blame = true, -- Enable current line blame
				current_line_blame_opts = {
					delay = 200, -- Delay before displaying blame info
					virt_text_pos = "eol", -- Position of virtual text (eol, right, inline)
				},
			})
			vim.api.nvim_set_keymap(
				"n",
				"<leader>hb",
				":lua require'gitsigns'.blame_line()<CR>",
				{ noremap = true, silent = true, desc = "Blame line" }
			)
		end,
	},
}
