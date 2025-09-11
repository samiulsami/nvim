local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.foldingRange = {
	dynamicRegistration = false,
	lineFoldingOnly = true,
}
vim.lsp.enable({
	"gopls",
	"lua_ls",
	"clangd",
	"dockerls",
	"helm_ls",
	"yamlls",
	"jsonls",
	"bashls",
})
vim.lsp.config("*", { capabilities = capabilities })
vim.lsp.inlay_hint.enable(false)

vim.api.nvim_set_hl(0, "LspReferenceText", { bold = true, underline = true })
vim.api.nvim_set_hl(0, "LspReferenceRead", { bold = true, underline = true })
vim.api.nvim_set_hl(0, "LspReferenceWrite", { bold = true, underline = true })

vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { desc = "LSP [R]e[n]ame" })
vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "LSP [C]ode [A]ction" })
vim.keymap.set("n", "<leader>RL", function()
	for _, client in pairs(vim.lsp.get_clients()) do
		client:stop(true)
	end
	vim.cmd("edit!")
end, { noremap = true, silent = true, desc = "[R]efresh [L]sp" })

vim.keymap.set("n", "<leader>th", function()
	local hinstsEnabled = vim.lsp.inlay_hint.is_enabled()
	vim.lsp.inlay_hint.enable(not hinstsEnabled)
	if not hinstsEnabled then
		vim.notify("Inlay hints enabled")
	else
		vim.notify("Inlay hints disabled")
	end
end, { desc = "[T]oggle Inlay [H]ints" })

vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("custom_lsp_attach", { clear = true }),
	callback = function(event)
		local client = vim.lsp.get_client_by_id(event.data.client_id)
		if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
			local highlight_augroup = vim.api.nvim_create_augroup("custom_lsp_highlight", { clear = false })

			vim.keymap.set(
				"n",
				"U",
				vim.lsp.buf.document_highlight,
				{ buffer = event.buf, desc = "LSP Document Highlight" }
			)

			vim.api.nvim_create_autocmd({ "CursorMoved" }, {
				buffer = event.buf,
				group = highlight_augroup,
				callback = vim.lsp.buf.clear_references,
			})

			vim.api.nvim_create_autocmd("LspDetach", {
				group = vim.api.nvim_create_augroup("custom_lsp_detach", { clear = true }),
				callback = function(event2)
					vim.lsp.buf.clear_references()
					vim.api.nvim_clear_autocmds({ group = "custom_lsp_highlight", buffer = event2.buf })
				end,
			})
		end
	end,
})
