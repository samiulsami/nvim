return {
	{
		"mfussenegger/nvim-lint",
		config = function()
			require("lint").linters_by_ft = {
				c = { "cpplint" },
				cpp = { "cpplint" },
				go = { "golangcilint" },
				yaml = { "yamllint" },
				bash = { "shellcheck" },
				json = { "jsonlint" },
				make = { "checkmake" },
				java = { "checkstyle" },
			}
			vim.keymap.set("n", "<leader>L", function()
				if vim.bo.modifiable then
					vim.notify("[Linting]", vim.log.levels.INFO)
					require("lint").try_lint()
				end
				vim.notify("[Cannot Lint file]", vim.log.levels.WARN)
			end, { noremap = true, silent = true, desc = "Run linters" })
		end,
	},
}
