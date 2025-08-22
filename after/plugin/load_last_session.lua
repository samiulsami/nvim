local arg = vim.fn.argv(0)
if type(arg) ~= "string" or arg ~= "." then
	return
end

local ok, persistence = pcall(require, "persistence")
if not ok then
	vim.notify("persistence.nvim not found", vim.log.levels.WARN)
	return
else
	persistence.load()
	vim.notify("Loaded last session at " .. vim.fn.getcwd(), vim.log.levels.INFO)
end

local ok, dart = pcall(require, "dart")
if not ok or not dart then
	vim.notify("dart.nvim not found", vim.log.levels.WARN)
	return
end

dart.read_session(vim.fn.sha256(vim.fn.getcwd()))
