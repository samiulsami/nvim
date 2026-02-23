vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.scrolloff = 10
vim.opt.signcolumn = "yes"
vim.opt.numberwidth = 3
vim.opt.fillchars:append({ vert = "|" })
vim.opt.laststatus = 2
vim.opt.termguicolors = true

vim.o.foldmethod = "indent"
vim.o.foldcolumn = "0"
vim.o.foldlevel = 99
vim.o.foldlevelstart = 99
vim.o.foldenable = true
vim.opt.fillchars:append({
	foldopen = "▾",
	foldclose = "▸",
	fold = " ",
	foldsep = " ",
	eob = " ",
})

vim.opt.list = true
vim.opt.listchars = { tab = "| ", trail = "·", nbsp = "␣" }

vim.api.nvim_create_autocmd("TextYankPost", {
	group = vim.api.nvim_create_augroup("HighlightOnYank", { clear = true }),
	callback = function()
		vim.hl.on_yank({ timeout = 350 })
	end,
})

vim.cmd.colorscheme("wildcharm")
require("utils.default_colors").set_colors()
