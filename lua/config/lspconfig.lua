-- :help grr
pcall(vim.api.nvim_del_keymap, "n", "grr") -- Unbind LSP [G]oto [R]eferences
pcall(vim.api.nvim_del_keymap, "n", "gri") -- UNbind LSP [G]oto [I]implementation
pcall(vim.api.nvim_del_keymap, "n", "gra") -- Unbind LSP Code Actions
pcall(vim.api.nvim_del_keymap, "n", "grn") -- Unbind LSP Rename
pcall(vim.api.nvim_del_keymap, "n", "grt") -- Unbind LSP Type Definition

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.foldingRange = {
	dynamicRegistration = false,
	lineFoldingOnly = true,
}
capabilities.textDocument.completion.completionItem.snippetSupport = false

vim.lsp.enable({
	"gopls",
	"lua_ls",
	"clangd",
	"scala",
	"dockerls",
	"helm_ls",
	"yamlls",
	"jsonls",
	"terraformls",
	"bashls",
})
vim.lsp.config("*", { capabilities = capabilities })
vim.lsp.inlay_hint.enable(false)

vim.diagnostic.config({
	underline = false,
	update_in_insert = false,
	virtual_text = false,
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = "󰅚 ",
			[vim.diagnostic.severity.WARN] = "󰀪 ",
			[vim.diagnostic.severity.INFO] = "󰋽 ",
			[vim.diagnostic.severity.HINT] = "󰌶 ",
		},
	},
})

vim.keymap.set(
	"n",
	"<leader>H",
	vim.diagnostic.open_float,
	{ noremap = true, silent = true, desc = "Toggle [H]over Diagnostic Float" }
)

vim.keymap.set("n", "]d", function()
	local ok, err = pcall(vim.diagnostic.jump, {
		count = 1,
		on_jump = function(_, bufnr)
			vim.diagnostic.open_float({ bufnr = bufnr, scope = "cursor", focus = false })
		end,
	})
	if not ok then
		vim.notify("Diagnostic error: " .. vim.inspect(err), vim.log.levels.ERROR)
	end
end, { noremap = true, silent = true, desc = "Jump to next Diagnostic" })

vim.keymap.set("n", "[d", function()
	local ok, err = pcall(vim.diagnostic.jump, {
		count = -1,
		on_jump = function(_, bufnr)
			vim.diagnostic.open_float({ bufnr = bufnr, scope = "cursor", focus = false })
		end,
	})
	if not ok then
		vim.notify("Diagnostic error: " .. vim.inspect(err), vim.log.levels.ERROR)
	end
end, { noremap = true, silent = true, desc = "Jump to previous Diagnostic" })

vim.api.nvim_set_hl(0, "LspReferenceText", { bold = true, underline = true })
vim.api.nvim_set_hl(0, "LspReferenceRead", { bold = true, underline = true })
vim.api.nvim_set_hl(0, "LspReferenceWrite", { bold = true, underline = true })

vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "LSP hover" })
vim.keymap.set("n", "<leader>gr", vim.lsp.buf.references, { desc = "Builtin LSP [R]eferences" })
vim.keymap.set("n", "<leader>gd", vim.lsp.buf.definition, { desc = "Builtin LSP [D]efinition" })
vim.keymap.set("n", "<leader>gi", vim.lsp.buf.implementation, { desc = "Builtin LSP [I]mplementation" })
vim.keymap.set("n", "<leader>gD", vim.lsp.buf.declaration, { desc = "Builtin LSP [D]eclaration" })

vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { desc = "LSP [R]e[n]ame" })
vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "LSP [C]ode [A]ction" })

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
			vim.keymap.set("n", "U", function()
				vim.lsp.buf.clear_references()
				vim.lsp.buf.document_highlight()
				vim.keymap.set("n", "<esc>", function()
					vim.lsp.buf.clear_references()
					vim.api.nvim_buf_del_keymap(event.buf, "n", "<esc>")
					return "<esc>"
				end, { buffer = event.buf, expr = true, desc = "Clear LSP references" })
			end, { buffer = event.buf, desc = "LSP Document Highlight" })

			vim.api.nvim_create_autocmd("LspDetach", {
				group = vim.api.nvim_create_augroup("custom_lsp_detach", { clear = true }),
				callback = vim.lsp.buf.clear_references,
			})
		end
	end,
})
