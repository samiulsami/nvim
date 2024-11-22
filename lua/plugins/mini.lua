return {

	{
		"echasnovski/mini.nvim",
		version = "*",
		config = function()
			require("mini.indentscope").setup({ draw = { delay = 10 }, symbol = "│" })
			-- require("mini.cursorword").setup({ delay = 10 })
			require("mini.statusline").setup()
		end,
	},
}
