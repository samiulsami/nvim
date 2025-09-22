return {
	"jiaoshijie/undotree",
	dependencies = { "nvim-lua/plenary.nvim" },
	---@module 'undotree.collector'
	---@type UndoTreeCollector.Opts
	opts = {
		window = { winblend = 0 },
	},
	keys = {
		{ "<leader>u", "<cmd>lua require('undotree').toggle()<cr>" },
	},
}
