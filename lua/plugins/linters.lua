return {
	{
		"mfussenegger/nvim-lint",
		config = function()
			require("lint").linters_by_ft = {
				c = { "cpplint" },
				-- cpp = { "cpplint" },
				go = { "golangcilint" },
				yaml = { "yamllint" },
				bash = { "shellcheck" },
				json = { "jsonlint" },
				make = { "checkmake" },
				java = { "checkstyle" },
			}
			vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
				callback = function()
					if vim.bo.modifiable then
						require("lint").try_lint()
					end
				end,
			})
		end,
	},
}
