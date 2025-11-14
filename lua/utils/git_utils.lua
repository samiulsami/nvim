---@param cmd string
---@return string, string | nil
local function run_shell_command(cmd)
	local result = vim.fn.system(cmd)
	if vim.v.shell_error ~= 0 then
		return "", result
	end
	return result:match("^%s*(.-)%s*$"), nil
end

---@param cmd table
---@return string, string | nil
local function run_shell_command_no_ui_block(cmd)
	local co = coroutine.running()
	vim.system(cmd, { text = true }, function(_)
		vim.schedule(function()
			coroutine.resume(co)
		end)
	end)
	return coroutine.yield()
end

local function select_blocking(items, opts)
	local co = coroutine.running()
	local result = nil
	vim.ui.select(items, opts or {}, function(choice)
		result = choice
		coroutine.resume(co)
	end)

	coroutine.yield()
	return result
end

vim.keymap.set("n", "<leader>gfp", function()
	coroutine.wrap(function()
		vim.notify("running 'git fetch --prune --all'", vim.log.levels.WARN)
		local result, err = run_shell_command_no_ui_block({ "git", "fetch", "--prune", "--all" })
		if err ~= nil then
			vim.notify(err, vim.log.levels.ERROR)
			return
		end
		if result and result ~= "" then
			vim.notify(result, vim.log.levels.INFO)
		else
			vim.notify("git fetch --prune --all completed with no output", vim.log.levels.INFO)
		end
	end)()
end, { desc = "[G]it [F]etch [P]rune" })

vim.keymap.set("n", "<leader>ghr", function()
	coroutine.wrap(function()
		local current_branch, err = run_shell_command("git branch --show-current")
		if err ~= nil then
			vim.notify(err, vim.log.levels.ERROR)
			return
		end

		local fetch_choice = select_blocking(
			{ "No", "Yes" },
			{ prompt = "🚨[HARD RESETTING] Run git fetch --prune --all?" }
		)
		if fetch_choice and fetch_choice == "Yes" then
			vim.notify("running 'git fetch --prune --all'", vim.log.levels.WARN)
			local result, err2 = run_shell_command_no_ui_block({ "git", "fetch", "--prune", "--all" })
			if err2 ~= nil then
				vim.notify(err2, vim.log.levels.ERROR)
				return
			end
			if result and result ~= "" then
				vim.notify(result, vim.log.levels.INFO)
			end
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

		local current_upstream, _ =
			run_shell_command("git rev-parse --abbrev-ref --symbolic-full-name @{u} 2>/dev/null")
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

		local selected_remote = select_blocking(remotes, { prompt = "🚨[HARD RESETTING] Select remote:" })
		if not selected_remote then
			return
		end

		local branches_result, branches_err = run_shell_command(
			"git branch -r --format='%(refname:short)' | grep '^"
				.. selected_remote
				.. "/' | sed 's/^"
				.. selected_remote
				.. "\\///'"
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

		local selected_branch =
			select_blocking(branches, { prompt = "🚨[HARD RESETTING] Select branch from " .. selected_remote .. ":" })
		if not selected_branch then
			return
		end

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
	end)()
end, {
	desc = "[G]it [H]ard [R]eset",
})

vim.keymap.set("n", "<leader>gm", function()
	local grep_command = "grep" -- NOTE: ripgrep's formatting differs slightly from grep in this case
	local result, err = run_shell_command(
		"git diff --name-only --diff-filter=U | xargs -r " .. grep_command .. " -Hn -E '^(<{7}|={7}|>{7}|\\|{7})'"
	)
	if err ~= nil then
		vim.notify("error running git command: " .. err, vim.log.levels.ERROR)
		return
	end

	if result == "" then
		vim.notify("No conflict markers found", vim.log.levels.INFO)
		return
	end

	local qf_list = {}
	for line in result:gmatch("[^\n]+") do
		local file, lnum = line:match("^([^:]+):(%d+):.*$")
		if file and lnum then
			table.insert(qf_list, { filename = file, lnum = tonumber(lnum), text = "" })
		end
	end

	if #qf_list == 0 then
		vim.notify("No conflict markers found", vim.log.levels.INFO)
		return
	end

	vim.fn.setqflist(qf_list)
	vim.cmd("copen")
	vim.notify("Loaded " .. #qf_list .. " conflict markers into quickfix", vim.log.levels.INFO)
end, { noremap = true, silent = true, desc = "Load git conflict markers into quickfix" })
