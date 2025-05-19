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
			}
			vim.api.nvim_create_autocmd({ "BufWritePost" }, {
				callback = function()
					require("lint").try_lint()
				end,
			})
		end,
	},
}
