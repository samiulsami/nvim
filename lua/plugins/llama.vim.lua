return {
	"ggml-org/llama.vim",
	init = function()
		local llama_utils = require("utils.llama_utils")

		vim.g.llama_config = {
			show_info = 0,
			endpoint = llama_utils:endpoint(),
			auto_fim = true,
			stop_strings = { "\n" },
			keymap_accept_full = "<C-o>",
			keymap_accept_word = "<C-k>",
		}

		vim.defer_fn(function()
			if not llama_utils:status() then
				vim.cmd("LlamaDisable")
			else
				vim.cmd("LlamaEnable")
				vim.api.nvim_set_hl(0, "llama_hl_hint", {
					fg = "#5f87d7",
					bg = "#111122",
					italic = true,
					ctermfg = 209,
				})
			end
		end, 0)
	end,
}
