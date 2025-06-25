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
vim.keymap.set("n", "<leader>RL", ":LspRestart", { noremap = true, silent = true, desc = "[R]efresh [L]sp" })
vim.keymap.set("n", "<leader>th", function()
	local hinstsEnabled = vim.lsp.inlay_hint.is_enabled()
	vim.lsp.inlay_hint.enable(not hinstsEnabled)
	if not hinstsEnabled then
		vim.notify("Inlay hints enabled")
	else
		vim.notify("Inlay hints disabled")
	end
end, { desc = "[T]oggle Inlay [H]ints" })
