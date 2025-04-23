return {
	{
		"tpope/vim-fugitive",
		config = function()
			vim.keymap.set("n", "<leader>gg", ":Git<CR>", {})
			vim.keymap.set("n", "<leader>gd", ":Gvdiffsplit!<CR>", { desc = "[G]it [D]iff [S]plit" })

			vim.keymap.set("n", "<leader>gl", ":Git log --oneline --full-history<CR>", { desc = "[G]it [L]og Oneline" })
			vim.keymap.set("n", "<leader>gL", ":Git log<CR>", { desc = "[G]it [L]og" })

			local function run_git_command(command)
				local result = vim.fn.system(command)
				if vim.v.shell_error ~= 0 then
					return "", result
				end
				return result, nil
			end

			vim.keymap.set("n", "<leader>ghr", function()
				local current_branch = vim.fn.FugitiveHead()
				local upstream = vim.fn.input("Hard resetting... \nSet upstream: ", "origin/" .. current_branch)
				if upstream:match("^%s*(.-)%s*$") == "" then
					vim.notify("Aborting hard reset", vim.log.levels.WARN)
					return
				end

				local _, err = run_git_command("git branch --set-upstream-to=" .. upstream .. " " .. current_branch)
				if err ~= nil then
					vim.notify(err, vim.log.levels.ERROR)
					return
				end

				local result = ""
				result, err = run_git_command("git fetch --prune --all")
				if err ~= nil then
					vim.notify(err, vim.log.levels.ERROR)
					return
				end
				vim.notify(result, vim.log.levels.INFO)

				result, err = run_git_command("git stash")
				if err ~= nil then
					vim.notify(err, vim.log.levels.ERROR)
					return
				end
				vim.notify("git stash\n" .. result, vim.log.levels.INFO)

				result, err = run_git_command("git reset --hard " .. upstream)
				if err ~= nil then
					vim.notify(err, vim.log.levels.ERROR)
					return
				end

				vim.notify("git reset --hard " .. upstream .. result, vim.log.levels.INFO)
			end, {
				desc = "[G]it [H]ard [R]eset",
			})

			vim.keymap.set("n", "<leader>gA", function()
				local result, err = run_git_command("git commit --amend --no-edit -s --allow-empty")
				if err ~= nil then
					vim.notify(err, vim.log.levels.ERROR)
					return
				end
				vim.cmd("Git")
				vim.notify(result, vim.log.levels.INFO)
			end, { desc = "[G]it Commit [A]mend" })

			vim.keymap.set("n", "<leader>gc", function()
				local input = vim.fn.input("git commit -m <msg> -s\nCommit message: ")
				if input:match("^%s*(.-)%s*$") == "" then
					vim.notify("Empty commit message. Aborting commit", vim.log.levels.WARN)
					return
				end

				local result, err = run_git_command("git commit -m '" .. input .. "' -s")
				if err ~= nil then
					vim.notify(err, vim.log.levels.ERROR)
					return
				end
				vim.cmd("Git")
				vim.notify(result, vim.log.levels.INFO)
			end, {
				desc = "[G]it [C]ommit",
			})

			vim.keymap.set("n", "<leader>gm", ":Git mergetool<CR>", { desc = "[G]it [M]ergetool" })

			vim.keymap.set("n", "<leader>B", function()
				local curPosXY = vim.api.nvim_win_get_cursor(0)
				local cursorPosition = curPosXY[2]
				local line = vim.api.nvim_get_current_line()

				-- FIXME: More complex patterns don't work well with matchstrpos, find the best one
				local pattern = [[\vhttps?://[a-zA-Z0-9._~:/?#@!$&'()*+,;=%-]+]]

				local closest_url = ""

				local pos = 0
				while pos < #line do
					local matchData = vim.fn.matchstrpos(line, pattern, pos)
					local url = matchData[1]
					local start = matchData[2]
					local end_ = matchData[3]

					if url == "" or start < 0 then
						break
					end

					if start <= cursorPosition and end_ > cursorPosition then
						closest_url = url
						break
					end

					pos = end_ + 1
				end

				if closest_url == "" then
					vim.notify("No URL found under cursor", vim.log.levels.WARN)
					return
				end

				local modified_url = vim.fn.input("Confirm url: ", closest_url)
				if modified_url == "" then
					return
				end

				vim.cmd("GBrowse " .. modified_url)
			end, { desc = "Open the URL under cursor in the cmdline with G[B]rowse" })
		end,
	},
}
