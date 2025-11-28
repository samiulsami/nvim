return {
	"Wansmer/treesj",
	config = function()
		local treesj = require("treesj")
		treesj.setup({
			use_default_keymaps = false,
			max_join_length = 9999,
		})

		vim.keymap.set({ "n", "v" }, "S", function()
			treesj.toggle()
		end, { desc = "Split or Join multiple lines" })
	end,
}
