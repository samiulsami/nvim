return {
	{
		"akinsho/toggleterm.nvim",
		config = function()
			require("toggleterm").setup({
				size = 13,
				open_mapping = [[<F12>]],
				-- change toggleterm working dir if vim pwd changes
				on_open = function(term)
					local nvim_dir = vim.fn.getcwd()
					if vim.b[term.bufnr].term_cwd ~= nvim_dir then
						vim.b[term.bufnr].term_cwd = nvim_dir
						term:send("cd " .. nvim_dir, false)
					end
				end,
				autochdir = true,
				start_in_insert = true,
				persist_size = false,
				persist_mode = false,
				insert_mappings = true, -- whether or not the open mapping applies in insert mode
				terminal_mappings = true, -- whether or not the open mapping applies in the opened terminals
				close_on_exit = true, -- close the terminal window when the process exits
				clear_env = false,
				hide_numbers = false,
				direction = "horizontal",
				auto_scroll = true,
				shell = vim.o.shell,
			})

			vim.keymap.set("t", "<C-q>", "<C-\\><C-n>", { desc = "Exit terminal mode" })
		end,
	},
}
