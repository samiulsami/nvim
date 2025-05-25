local arg = vim.fn.argv(0)
if type(arg) ~= "string" or arg ~= "." then
	return
end

local ok, persistence = pcall(require, "persistence")
if not ok then
	vim.notify("persistence.nvim not found")
	return
else
	persistence.load()
	vim.notify("Loaded last session at " .. vim.fn.getcwd(), vim.log.levels.INFO)
end
