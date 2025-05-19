return {
	"stevearc/conform.nvim",
	event = { "BufWritePre" },
	cmd = { "ConformInfo" },
	opts = {
		notify_on_error = false,
		format_on_save = function(bufnr)
			local disable_filetypes = { c = true, cpp = true }
			local lsp_format_opt
			if disable_filetypes[vim.bo[bufnr].filetype] then
				lsp_format_opt = "never"
			else
				lsp_format_opt = "fallback"
			end
			return {
				timeout_ms = 1000,
				lsp_format = lsp_format_opt,
			}
		end,
		formatters_by_ft = {
			lua = { "stylua" }, -- done
			go = {
				"gofumpt",
				"goimports",
				-- "golines",
			},
			cpp = { "clang-format" },
			c = { "clang-format" },
			yaml = { "yamlfix" },
			json = { "fixjson" },
			bash = { "shfmt" },
		},
	},
}
