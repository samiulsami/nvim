return {
	{
		"akinsho/toggleterm.nvim",
		config = function()
			require("toggleterm").setup({
				size = 13,
				open_mapping = [[<F12>]],

				autochdir = true,
				start_in_insert = true,
				persist_size = true,
				persist_mode = false,
				insert_mappings = true, -- whether or not the open mapping applies in insert mode
				terminal_mappings = true, -- whether or not the open mapping applies in the opened terminals
				close_on_exit = true, -- close the terminal window when the process exits
				clear_env = false,
				hide_numbers = false,
				direction = "float",
				float_opts = {
					border = { " ", "─", " ", " ", " ", " ", " ", " " },
					winblend = 16,
					width = 999999,
					height = 13,
					row = 999999,
				},

				auto_scroll = true,
				shell = vim.o.shell,
			})

			vim.keymap.set("t", "<C-q>", "<C-\\><C-n>", { desc = "Exit terminal mode" })
			vim.keymap.set("t", "<C-h>", [[<Cmd>wincmd h<CR>]])
			vim.keymap.set("t", "<C-j>", [[<Cmd>wincmd j<CR>]])
			vim.keymap.set("t", "<C-k>", [[<Cmd>wincmd k<CR>]])
			vim.keymap.set("t", "<C-l>", [[<Cmd>wincmd l<CR>]])
			-- vim.keymap.set("t", "<C-w>", function()
			-- 	local term = require("toggleterm.terminal").get(vim.b.toggle_number)
			-- 	if term and term:is_open() then
			-- 		term.close(term)
			-- 	end
			-- end)
			--

			vim.api.nvim_create_autocmd({
				"TermEnter",
			}, { pattern = "*", command = "set number" })
		end,
	},
}
