return {
	"ggml-org/llama.vim",
	init = function()
		vim.g.llama_config = {
			show_info = 0,
			endpoint = "http://127.0.0.1:11397/infill",
			max_line_suffix = 20,
			auto_fim = true,
			keymap_accept_full = "<C-j>",
			keymap_accept_line = "<C-k>",
			ring_n_chunks = 64,
			ring_chunk_Size = 64,
			ring_scope = 2048,
			n_prefix = 2048,
		}

		vim.defer_fn(function()
			vim.api.nvim_set_hl(0, "llama_hl_hint", { fg = "#859289", italic = true, ctermfg = 209 })
		end, 0)
	end,
}
