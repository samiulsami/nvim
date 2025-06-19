return {
	"nanozuki/tabby.nvim",
	config = function()
		local lualine_theme = "tokyonight"
		local ok, ll_theme = pcall(require, string.format("lualine.themes.%s", lualine_theme))
		if not ok then
			vim.notify(string.format("tabby.nvim: lualine theme %s not found", lualine_theme), vim.log.levels.ERROR)
			return
		end
		local theme = {
			fill = ll_theme.normal.c,
			head = ll_theme.visual.a,
			current_tab = ll_theme.normal.a,
			tab = ll_theme.normal.b,
			win = ll_theme.normal.b,
			tail = ll_theme.normal.b,
		}

		local jump_chars = { "a", "s", "d", "f", "z", "x", "c", "v" }
		require("tabby").setup({})

		require("tabby.tabline").set(function(line)
			return {
				line.tabs().foreach(function(tab)
					local hl = tab.is_current() and theme.current_tab or theme.tab
					return {
						line.sep(" ", hl, theme.fill),
						tab.number() <= #jump_chars and string.format("[%s]", jump_chars[tab.number()]),
						tab.name(),
						line.sep(" ", hl, theme.fill),
						hl = hl,
						margin = " ",
					}
				end),
				hl = theme.fill,
			}
		end)

		vim.keymap.set("n", "<leader>tn", "<Cmd>tab split<CR>", { noremap = true })
		vim.keymap.set("n", "<leader>tr", ":Tabby rename_tab ", { noremap = true })
		vim.keymap.set("n", "<leader>tc", "<Cmd>tabclose<CR>", { noremap = true })
		vim.keymap.set("n", "<leader>tO", "<Cmd>tabonly<CR>", { noremap = true })
		vim.keymap.set("n", "<leader>tmp", "<Cmd>-tabmove<CR>", { noremap = true })
		vim.keymap.set("n", "<leader>tmn", "<Cmd>+tabmove<CR>", { noremap = true })
		vim.keymap.set({ "t", "i", "n" }, "<A-a>", "<Cmd>tabnext 1<CR>", { noremap = true, silent = true })
		vim.keymap.set({ "t", "i", "n" }, "<A-s>", "<Cmd>tabnext 2<CR>", { noremap = true, silent = true })
		vim.keymap.set({ "t", "i", "n" }, "<A-d>", "<Cmd>tabnext 3<CR>", { noremap = true, silent = true })
		vim.keymap.set({ "t", "i", "n" }, "<A-f>", "<Cmd>tabnext 4<CR>", { noremap = true, silent = true })
		vim.keymap.set({ "t", "i", "n" }, "<A-z>", "<Cmd>tabnext 5<CR>", { noremap = true, silent = true })
		vim.keymap.set({ "t", "i", "n" }, "<A-x>", "<Cmd>tabnext 6<CR>", { noremap = true, silent = true })
		vim.keymap.set({ "t", "i", "n" }, "<A-c>", "<Cmd>tabnext 7<CR>", { noremap = true, silent = true })
		vim.keymap.set({ "t", "i", "n" }, "<A-v>", "<Cmd>tabnext 8<CR>", { noremap = true, silent = true })
	end,
}
