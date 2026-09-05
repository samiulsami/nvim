---@type PluginSpec
return {
	src = "https://github.com/maxonvim/hi-pos.nvim",
	config = function()
		local pos = require("hi_pos").setup()

		vim.keymap.set("n", "<leader>h", pos.toggle, { desc = "Start POS highlighting" })
	end,
}
