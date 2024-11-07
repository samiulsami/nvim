return {
	{
		"tpope/vim-fugitive",
		config = function()
			vim.keymap.set("n", "<leader>gg", ":Git<CR>", {})
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
					delay = 100, -- Delay before displaying blame info
					virt_text_pos = "right_align", -- Position of virtual text (eol, right, inline)
				},
			})
			vim.api.nvim_set_keymap(
				"n",
				"<leader>gsb",
				":lua require'gitsigns'.blame_line()<CR>",
				{ noremap = true, silent = true, desc = "[G]it [S]igns [B]lame line" }
			)
			vim.api.nvim_set_keymap(
				"n",
				"<leader>gsB",
				":Gitsigns toggle_current_line_blame<CR>",
				{ noremap = true, silent = true, desc = "Toggle [G]it [S]igns [B]lame line " }
			)
			vim.api.nvim_set_keymap(
				"n",
				"<leader>gsw",
				":Gitsigns toggle_word_diff<CR>",
				{ noremap = true, silent = true, desc = "Toggle [G]it [S]igns [W]ord diff" }
			)

			vim.api.nvim_set_keymap(
				"n",
				"<leader>gsl",
				":Gitsigns toggle_linehl<CR>",
				{ noremap = true, silent = true, desc = "Toggle [G]it [S]igns [L]ine Highlight" }
			)
			vim.api.nvim_set_keymap(
				"n",
				"<leader>gsn",
				":Gitsigns toggle_numhl<CR>",
				{ noremap = true, silent = true, desc = "Toggle [G]it [S]igns [N]um highlight" }
			)
		end,
	},
}
