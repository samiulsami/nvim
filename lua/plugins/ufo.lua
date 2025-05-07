return {
	"kevinhwang91/nvim-ufo",
	dependencies = {
		"kevinhwang91/promise-async",
	},
	config = function()
		local ufo = require("ufo")
		vim.keymap.set("n", "zR", ufo.openAllFolds)
		vim.keymap.set("n", "zM", ufo.closeAllFolds)
		ufo.setup()
	end,
}
