vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.scrolloff = 10
vim.opt.signcolumn = "yes"
vim.opt.numberwidth = 3
vim.opt.fillchars:append({ vert = "|" })
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.expandtab = true
vim.opt.laststatus = 2
vim.opt.termguicolors = true

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

vim.opt.ignorecase = true
vim.opt.hlsearch = true
vim.opt.incsearch = true

vim.opt.showmode = false

vim.opt.breakindent = true
vim.opt.wrap = false
vim.opt.smartcase = true

vim.opt.inccommand = "split"

vim.opt.splitright = true
vim.opt.splitbelow = true

vim.opt.list = true
vim.opt.listchars = { tab = "| ", trail = "·", nbsp = "␣" }
