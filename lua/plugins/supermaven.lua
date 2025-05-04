return {
	"supermaven-inc/supermaven-nvim",
	config = function()
		local llama_utils = require("utils.llama_utils")

		require("supermaven-nvim").setup({
			keymaps = {
				accept_suggestion = "<c-j>",
				clear_suggestion = "<c-h>",
				accept_word = "<c-k>",
			},
			log_level = "off",
		})

		vim.defer_fn(function()
			if llama_utils:status() then
				vim.cmd("SupermavenStop")
			else
				vim.notify("Enabled supermaven.nvim")
				vim.cmd("SupermavenStart")
			end
		end, 0)
	end,
}
