return {
	"ggandor/leap.nvim",
	config = function()
		require("leap").opts.safe_labels = ""
		vim.keymap.set({ "n", "x", "o" }, "s", "<Plug>(leap)")
		vim.api.nvim_set_hl(0, "LeapLabel", { fg = "#ff4400", italic = true, bold = true })
	end,
}
