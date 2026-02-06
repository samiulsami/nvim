return {
	spec = {
		{ src = "https://github.com/nvim-lua/plenary.nvim" },
		{ src = "https://github.com/jiaoshijie/undotree" },
	},
	config = function()
		require("undotree").setup({
			window = { winblend = 0 },
		})
		vim.keymap.set("n", "<leader>u", function()
			require("undotree").toggle()
		end)
	end,
}
