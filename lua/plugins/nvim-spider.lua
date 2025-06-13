return {
	"chrisgrieser/nvim-spider",
	lazy = false,
	config = function()
		local spider = require("spider")
		vim.keymap.set({ "n", "o", "x" }, "w", function()
			spider.motion("w")
		end, {})
		vim.keymap.set({ "n", "o", "x" }, "e", function()
			spider.motion("e")
		end, {})
		vim.keymap.set({ "n", "o", "x" }, "b", function()
			spider.motion("b")
		end, {})
	end,
}
