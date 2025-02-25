return {
	{
		"tpope/vim-fugitive",
		config = function()
			vim.keymap.set("n", "<leader>gg", ":Git<CR>", {})
			vim.keymap.set("n", "<leader>gd", ":Gvdiffsplit!<CR>", { desc = "[G]it [D]iff [S]plit" })
			vim.keymap.set("n", "<leader>gb", ":Git blame<CR>", { desc = "[G]it [B]lame" })

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

				local upstream, err = run_git_command("git rev-parse --abbrev-ref --symbolic-full-name @{upstream}")
				if upstream == "" and err ~= nil and err:match("fatal: no upstream configured for branch '") then
					upstream = vim.fn.input(
						"Upstream not found for branch '" .. current_branch .. "'.\nSet upstream: ",
						"origin/" .. current_branch
					)
					_, err = run_git_command("git branch --set-upstream-to=" .. upstream .. " " .. current_branch)
					if err ~= nil then
						vim.notify(err, vim.log.levels.ERROR)
						return
					end
				elseif err ~= nil then
					vim.notify(err, vim.log.levels.ERROR)
					return
				end

				if vim.fn.input("Hard reset? (y/n) "):lower() ~= "y" then
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
				vim.cmd("Git")
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
		end,
	},
}
