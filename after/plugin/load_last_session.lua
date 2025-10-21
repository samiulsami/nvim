local arg = vim.fn.argv(0)
if type(arg) ~= "string" or arg ~= "." then
	return
end

local ok, _ = pcall(function(cmd)
	vim.cmd(cmd)
end, "AutoSession restore")
if not ok then
	vim.notify("error restoring session with AutoSession", vim.log.levels.WARN)
	return
end

vim.notify("Loaded last session at " .. vim.fn.getcwd(), vim.log.levels.INFO)
