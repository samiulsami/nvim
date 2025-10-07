local file_ignore_patterns = {
	"^node_modules/",
	"^.git/",
	"^vendor/",
	"^zz_generated",
	"^openapi_generated",
}
local active_ignore_patterns = file_ignore_patterns
local disable_ignore_patterns = false

vim.keymap.set("n", "<leader>ti", function()
	if disable_ignore_patterns then
		active_ignore_patterns = file_ignore_patterns
		vim.notify("Set ignore patterns to:\n" .. vim.inspect(active_ignore_patterns))
	else
		vim.notify("Ignore patterns disabled")
		active_ignore_patterns = nil
	end
	disable_ignore_patterns = not disable_ignore_patterns
end, { desc = "[T]oggle [I]gnore patterns" })

return file_ignore_patterns
