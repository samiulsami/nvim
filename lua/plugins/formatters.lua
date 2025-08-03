return {
	"stevearc/conform.nvim",
	lazy = false,
	cmd = { "ConformInfo" },
	config = function()
		local conform = require("conform")
		conform.setup({
			notify_on_error = false,
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
				-- java = { "google-java-format" },
			},
		})

		vim.keymap.set("n", "<leader>F", function()
			local disable_filetypes = { c = true, cpp = true }
			local lsp_format_opt
			local bufnr = vim.api.nvim_get_current_buf()
			if disable_filetypes[vim.bo[bufnr].filetype] then
				lsp_format_opt = "never"
			else
				lsp_format_opt = "fallback"
			end
			conform.format({ timeout_ms = 2000, lsp_format = lsp_format_opt })
		end, { desc = "Format buffer" })
	end,
}
