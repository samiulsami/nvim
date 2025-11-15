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
				terraform = { "tflint" },
				make = { "checkmake" },
				java = { "checkstyle" },
			}
			vim.keymap.set("n", "<leader>L", function()
				if not vim.bo.modifiable then
					vim.notify("[Cannot Lint file]", vim.log.levels.WARN)
					return
				end
				vim.notify("[Linting]", vim.log.levels.INFO)
				require("lint").try_lint()
			end, { noremap = true, silent = true, desc = "Run linters" })
		end,
	},
}
