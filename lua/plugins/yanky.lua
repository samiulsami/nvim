return {
	"gbprod/yanky.nvim",
	lazy = false,
	opts = {
		ring = {
			update_register_on_cycle = true,
		},
		highlight = {
			timer = 250,
		},
	},
	dependencies = { "folke/snacks.nvim" },
	--stylua: ignore
	keys = {
		{ "<leader>sy", function() Snacks.picker.yanky() end, mode = { "n", "x" }, desc = "Open Yank History" },
		{ "<c-p>", "<Plug>(YankyPreviousEntry)", mode = { "n" } },
		{ "<c-n>", "<Plug>(YankyNextEntry)", mode = { "n" } },
		{ "p", "<Plug>(YankyPutAfter)", mode = { "n", "x" } },
		{ "P", "<Plug>(YankyPutBefore)", mode = { "n", "x" } },
	},
}
