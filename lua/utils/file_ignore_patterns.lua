---@class file_ignore_patterns
---@field private patterns table<string> | nil
---@field public get_patterns fun(): table<string>
local M = {}

M.get_patterns = function()
	return vim.list_extend({}, M.patterns or {})
end

local file_ignore_patterns = {
	"^node_modules/",
	"^.git/",
	"^vendor/",
	"^zz_generated",
	"^openapi_generated",
}

M.patterns = file_ignore_patterns

vim.keymap.set("n", "<leader>ti", function()
	if M.patterns == nil then
		M.patterns = file_ignore_patterns
		vim.notify("Enabled ignore patterns:\n" .. vim.inspect(M.patterns), vim.log.levels.INFO)
	else
		M.patterns = nil
		vim.notify("Disabled ignore patterns", vim.log.levels.WARN)
	end
end, { desc = "[T]oggle [I]gnore patterns" })

return M
