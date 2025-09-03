---@param cmd string
---@return string, string | nil
local function run_shell_command(cmd)
	local result = vim.fn.system(cmd)
	if vim.v.shell_error ~= 0 then
		return "", result
	end
	return result:match("^%s*(.-)%s*$"), nil
end

vim.keymap.set("n", "<leader>gfp", function()
	local result, err = run_shell_command("git fetch --prune --all")
	if err ~= nil then
		vim.notify(err, vim.log.levels.ERROR)
		return
	end
	vim.notify(result, vim.log.levels.INFO)
end, { desc = "[G]it [F]etch [P]rune" })

vim.keymap.set("n", "<leader>ghr", function()
	local current_branch, err = run_shell_command("git branch --show-current")
	if err ~= nil then
		vim.notify(err, vim.log.levels.ERROR)
		return
	end

	local remotes_result, err2 = run_shell_command("git remote")
	if err2 ~= nil then
		vim.notify(err2, vim.log.levels.ERROR)
		return
	end

	local remotes = {}
	for remote in remotes_result:gmatch("[^\n]+") do
		table.insert(remotes, remote)
	end

	if #remotes == 0 then
		vim.notify("No remotes found", vim.log.levels.ERROR)
		return
	end

	local current_upstream, _ = run_shell_command("git rev-parse --abbrev-ref --symbolic-full-name @{u} 2>/dev/null")
	local current_remote = nil
	if current_upstream ~= "" then
		current_remote = current_upstream:match("^([^/]+)/")
	end

	if current_remote then
		for i, remote in ipairs(remotes) do
			if remote == current_remote then
				table.remove(remotes, i)
				table.insert(remotes, 1, current_remote)
				break
			end
		end
	elseif vim.tbl_contains(remotes, "origin") then
		for i, remote in ipairs(remotes) do
			if remote == "origin" then
				table.remove(remotes, i)
				table.insert(remotes, 1, "origin")
				break
			end
		end
	end

	vim.ui.select(remotes, {
		prompt = "🚨[HARD RESETTING] Select remote:",
	}, function(selected_remote)
		local branches_result, branches_err = run_shell_command(
			"git branch -r | grep '^[[:space:]]*"
				.. selected_remote
				.. "/' | sed 's/^[[:space:]]*"
				.. selected_remote
				.. "\\///' | grep -v 'HEAD ->'"
		)
		if branches_err ~= nil then
			vim.notify(branches_err, vim.log.levels.ERROR)
			return
		end

		local branches = {}
		for branch in branches_result:gmatch("[^\n]+") do
			local trimmed_branch = branch:match("^%s*(.-)%s*$")
			if trimmed_branch ~= "" then
				table.insert(branches, trimmed_branch)
			end
		end

		if #branches == 0 then
			vim.notify("No remote branches found for " .. selected_remote, vim.log.levels.ERROR)
			return
		end

		for i, branch in ipairs(branches) do
			if branch == current_branch then
				table.remove(branches, i)
				table.insert(branches, 1, current_branch)
				break
			end
		end

		vim.ui.select(branches, {
			prompt = "🚨[HARD RESETTING] Select branch from " .. selected_remote .. ":",
		}, function(selected_branch)
			local upstream = selected_remote .. "/" .. selected_branch

			_, err2 = run_shell_command("git branch --set-upstream-to=" .. upstream .. " " .. current_branch)
			if err2 ~= nil then
				vim.notify(err2, vim.log.levels.ERROR)
				return
			end

			local result, err3 = run_shell_command("git stash")
			if err3 ~= nil then
				vim.notify(err3, vim.log.levels.ERROR)
				return
			end
			vim.notify("git stash " .. result, vim.log.levels.INFO)

			result, err3 = run_shell_command("git reset --hard " .. upstream)
			if err3 ~= nil then
				vim.notify(err3, vim.log.levels.ERROR)
				return
			end

			vim.notify("git reset --hard " .. upstream .. result, vim.log.levels.INFO)
		end)
	end)
end, {
	desc = "[G]it [H]ard [R]eset",
})
