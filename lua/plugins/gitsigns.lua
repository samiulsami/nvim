return {
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

			local gitsigns = require("gitsigns")

			vim.keymap.set(
				"n",
				"<leader>gsb",
				gitsigns.blame_line,
				{ noremap = true, silent = true, desc = "[G]it [S]igns [B]lame line" }
			)
			vim.keymap.set(
				"n",
				"<leader>gsB",
				gitsigns.toggle_current_line_blame,
				{ noremap = true, silent = true, desc = "Toggle [G]it [S]igns [B]lame line " }
			)
			vim.keymap.set(
				"n",
				"<leader>gsw",
				gitsigns.toggle_word_diff,
				{ noremap = true, silent = true, desc = "Toggle [G]it [S]igns [W]ord diff" }
			)

			vim.keymap.set(
				"n",
				"<leader>gsl",
				gitsigns.toggle_linehl,
				{ noremap = true, silent = true, desc = "Toggle [G]it [S]igns [L]ine Highlight" }
			)
			vim.keymap.set(
				"n",
				"<leader>gsn",
				gitsigns.toggle_numhl,
				{ noremap = true, silent = true, desc = "Toggle [G]it [S]igns [N]um highlight" }
			)

			vim.keymap.set("n", "<leader>gha", gitsigns.stage_hunk, { desc = "[G]it [H]unk [A]dd" })
			vim.keymap.set("n", "<leader>ghr", gitsigns.reset_hunk, { desc = "[G]it [H]unk [R]eset" })
			vim.keymap.set("v", "<leader>gha", function()
				gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
			end, { desc = "[G]it [H]unk [A]dd" })

			vim.keymap.set("v", "<leader>ghr", function()
				gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
			end, { desc = "[G]it [H]unk [R]eset" })

			vim.keymap.set("n", "<leader>gS", gitsigns.stage_buffer, { desc = "[G]it [S]tage Buffer" })
		end,
	},
}
