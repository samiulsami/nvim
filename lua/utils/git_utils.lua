---@param cmd string
---@return string, string | nil
local function run_shell_command(cmd)
	local result = vim.fn.system(cmd)
	if vim.v.shell_error ~= 0 then
		return "", result
	end
	return result:match("^%s*(.-)%s*$"), nil
end

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
