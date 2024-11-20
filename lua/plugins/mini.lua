return {

	{
		"echasnovski/mini.nvim",
		version = "*",
		config = function()
			require("mini.indentscope").setup({ draw = { delay = 10 }, symbol = "│" })
			require("mini.completion").setup()
			require("mini.cursorword").setup({ delay = 10 })
		end,
	},
}
