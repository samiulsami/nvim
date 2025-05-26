return {
	"supermaven-inc/supermaven-nvim",
	config = function()
		local llama_utils = require("utils.llama_utils")
		require("supermaven-nvim").setup({
			keymaps = {
				accept_suggestion = "<C-o>",
				clear_suggestion = "<C-h>",
				accept_word = "<C-k>",
			},
			log_level = "off",
		})

		local supermaven_api = require("supermaven-nvim.api")
		vim.defer_fn(function()
			if llama_utils:status() == supermaven_api.is_running() then
				supermaven_api.toggle()
			end
		end, 0)
	end,
}
