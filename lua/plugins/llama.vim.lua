return {
	"samiulsami/llama.vim",
	branch = "single-line",
	init = function()
		local llama_utils = require("utils.llama_utils")

		vim.g.llama_config = {
			show_info = 0,
			endpoint = llama_utils.host .. ":" .. llama_utils.port .. "/infill",
			max_line_suffix = 9999999,
			auto_fim = true,
			stop_strings = { "\n" },
			keymap_accept_full = "<C-j>",
			keymap_accept_line = "<C-k>",
			ring_n_chunks = 2048,
			ring_chunk_Size = 2048,
			ring_scope = 2048,
			n_prefix = 2048,
		}

		vim.defer_fn(function()
			if not llama_utils:status() then
				vim.cmd("LlamaDisable")
			else
				vim.cmd("LlamaEnable")
				vim.api.nvim_set_hl(0, "llama_hl_hint", { fg = "#C59289", italic = true, ctermfg = 209 })
			end
		end, 0)
	end,
}
