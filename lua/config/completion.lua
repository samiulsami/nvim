vim.opt.completeopt = { "menu", "menuone", "popup", "noselect", "fuzzy" }
vim.opt.complete = { "F", "o" }
vim.opt.omnifunc = "v:lua.vim.lsp.omnifunc"

vim.opt.autocomplete = true
vim.opt.wildmode = { "noselect:lastused", "full" }
vim.opt.wildoptions = { "pum", "fuzzy" }

local function should_skip_cmdline_autocomplete()
	if vim.fn.getcmdtype() ~= ":" then
		return false
	end

	local cmdline = vim.fn.getcmdline()
	return cmdline:match("^%s*Gitsigns%f[%W]") ~= nil
		or cmdline:match("^%s*Git%f[%W]") ~= nil
		or cmdline:match("^%s*G%f[%W]") ~= nil
end

--- Only janky part about native completion as of 'Wed May 27 03:32:18 AM +06 2026'
--- issues (That were absent in blink.cmp):
---  - Can't mimic insert-mode manual completion behavior
---  - Can't bind the same key to trigger completion, or cycle through them if already triggered.
---  - Completion source not identifiable.
---  - Fuzzy matching unavailable for ':help'
vim.api.nvim_create_autocmd("CmdlineChanged", {
	group = vim.api.nvim_create_augroup("native_cmdline_completion", { clear = true }),
	pattern = { "/", ":", "?" },
	callback = function()
		if should_skip_cmdline_autocomplete() then
			return
		end

		pcall(vim.fn.wildtrigger)
	end,
})
