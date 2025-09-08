return {
	"stevearc/conform.nvim",
	lazy = false,
	cmd = { "ConformInfo" },
	config = function()
		local conform = require("conform")
		conform.setup({
			notify_on_error = false,
			formatters_by_ft = {
				lua = { "stylua" },
				go = { "gofumpt", "goimports" },
				cpp = { "clang-format" },
				c = { "clang-format" },
				yaml = { "yamlfix" },
				json = { "fixjson" },
				bash = { "shfmt" },
				["*"] = { "trim_whitespace" },
			},
		})

		vim.keymap.set({ "n", "v" }, "<leader>F", function()
			local disable_filetypes = { c = true, cpp = true }
			local lsp_format_opt
			local bufnr = vim.api.nvim_get_current_buf()
			if disable_filetypes[vim.bo[bufnr].filetype] then
				lsp_format_opt = "never"
			else
				lsp_format_opt = "fallback"
			end
			conform.format({ timeout_ms = 2000, lsp_format = lsp_format_opt })
			vim.notify("[Formatting]", vim.log.levels.INFO)
		end, { desc = "Format buffer" })
	end,
}
