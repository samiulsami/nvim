return {
	{
		"lewis6991/gitsigns.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim", -- Required dependency
		},
		config = function()
			local on_attach = function(bufnr)
				local gitsigns = require("gitsigns")
				vim.keymap.set(
					"n",
					"<leader>gtb",
					gitsigns.toggle_current_line_blame,
					{ noremap = true, silent = true, desc = "[G]it [T]oggle [B]lame line" }
				)
				vim.keymap.set("n", "<leader>gth", function()
					gitsigns.toggle_word_diff()
					gitsigns.toggle_linehl()
				end, { noremap = true, silent = true, desc = "[G]it [T]oggle Word Diff [H]ighlights" })

				local function map(mode, l, r, opts)
					opts = opts or {}
					opts.buffer = bufnr
					vim.keymap.set(mode, l, r, opts)
				end

				map("n", "<leader>gtd", gitsigns.toggle_deleted, { desc = "[G]it [T]oggle [D]eleted" })

				map("n", "<leader>hs", gitsigns.stage_hunk, { desc = "Git [H]unk [S]tage" })
				map("n", "<leader>hr", gitsigns.reset_hunk, { desc = "Git [H]unk [R]eset" })
				map("v", "<leader>hs", function()
					gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
				end, { desc = "Git [H]unk [S]tage" })
				map("v", "<leader>hr", function()
					gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
				end, { desc = "Git [H]unk [R]eset" })
				map("n", "<leader>hS", gitsigns.stage_buffer, { desc = "Git [H]unk [S]tage Buffer" })
				map("n", "<leader>hu", gitsigns.undo_stage_hunk, { desc = "Git [H]unk [U]ndo Stage Hunk" })
				map("n", "<leader>hR", gitsigns.reset_buffer, { desc = "Git [H]unk [R]eset Buffer" })
				map("n", "<leader>hp", gitsigns.preview_hunk, { desc = "Git [H]unk [P]review" })
			end

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
				on_attach = on_attach,
			})
		end,
	},
}
