vim.opt.completeopt = { "menu", "menuone", "popup", "noselect", "fuzzy" }
vim.opt.complete = { ".", "w", "b", "u", "t", "o" }
vim.opt.pumheight = 9

vim.opt.autocomplete = false
vim.opt.wildmode = { "noselect:lastused", "full" }
vim.opt.wildoptions = { "pum", "fuzzy" }

vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("native_lsp_completion", { clear = true }),
	callback = function(event)
		local client = vim.lsp.get_client_by_id(event.data.client_id)
		if not client then
			return
		end

		vim.bo[event.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

		if client.name == "gopls" and vim.bo[event.buf].filetype == "go" then
			local ok, cmp_go_deep = pcall(require, "cmp_go_deep")
			if ok then
				cmp_go_deep.attach_to_buffer(event.buf)
			end
		end

		if not client:supports_method(vim.lsp.protocol.Methods.textDocument_completion) then
			return
		end

		vim.lsp.completion.enable(true, client.id, event.buf, {
			autotrigger = true,
		})
	end,
})

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
		pcall(vim.fn.wildtrigger)
	end,
})
