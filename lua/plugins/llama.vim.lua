return {
	"ggml-org/llama.vim",
	init = function()
		local llama = require("utils.llama")

		vim.g.llama_config = {
			show_info = 0,
			endpoint = llama:endpoint(),
			auto_fim = true,
			stop_strings = { "\n" },
			keymap_accept_full = "<C-k>",
			keymap_accept_line = "<C-o>",
			keymap_accept_word = "<C-j>",
		}

		vim.defer_fn(function()
			if not llama:status() then
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
