return {
	{
		"tpope/vim-fugitive",
		config = function()
			vim.keymap.set("n", "<leader>gg", ":Git<CR>", {})
			vim.keymap.set("n", "<leader>gd", ":Gvdiffsplit!<CR>", { desc = "[G]it [D]iff [S]plit" })
			vim.keymap.set("n", "<leader>gb", ":Git blame<CR>", { desc = "[G]it [B]lame" })

			vim.keymap.set("n", "<leader>gl", ":Git log --oneline --full-history<CR>", { desc = "[G]it [L]og Oneline" })

			vim.keymap.set("n", "<leader>ghr", function()
				if vim.fn.input("Hard reset? (y/n)"):lower() ~= "y" then
					return
				end
				vim.cmd("Git fetch --prune --all")
				vim.cmd("Git reset --hard @{upstream}")
			end, {
				desc = "[G]it [H]ard [R]eset",
			})

			vim.keymap.set("n", "<leader>gA", ":Git commit --amend --no-edit -s<CR>", { desc = "[G]it Commit [A]mend" })

			vim.keymap.set("n", "<leader>gac", function()
				local input = vim.fn.input("git add . ; git commit -m <msg> -s\nCommit message: ")
				if input:match("^%s*(.-)%s*$") == "" then
					vim.notify("Empty commit message. Aborting commit", vim.log.levels.WARN)
					return
				end
				vim.cmd("Git add .")
				vim.cmd("Git commit  -m '" .. input .. "' -s")
			end, {
				desc = "[G]it Add All [C]ommit",
			})

			vim.keymap.set("n", "<leader>gc", function()
				local input = vim.fn.input("git commit -m <msg> -s\nCommit message: ")
				if input:match("^%s*(.-)%s*$") == "" then
					vim.notify("Empty commit message. Aborting commit", vim.log.levels.WARN)
					return
				end
				vim.cmd("Git commit  -m '" .. input .. "' -s")
			end, {
				desc = "[G]it [C]ommit",
			})
		end,
	},
}
