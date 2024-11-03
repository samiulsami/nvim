vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.scrolloff = 10
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")

vim.opt.numberwidth = 3
vim.opt.fillchars:append({ vert = "|" })
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.cursorline = false
vim.opt.laststatus = 2
vim.opt.termguicolors = true

vim.opt.updatetime = 300
vim.opt.autoread = true

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()" -- Enable case-insensitive search and highlight matchesk
vim.opt.foldlevel = 99

vim.opt.ignorecase = true
vim.opt.hlsearch = false
vim.opt.incsearch = true

-- Enable mouse support
vim.opt.mouse = "a"
vim.opt.showmode = false

vim.opt.grepprg = "rg --vimgrep --no-heading --smart-case"
vim.opt.grepformat = "%f:%l:%m"

vim.schedule(function()
	vim.opt.clipboard = "unnamedplus"
end)

vim.opt.breakindent = true

vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Preview substitutions live, as you type!
vim.opt.inccommand = "split"

-- Configure how new splits should be opened
vim.opt.splitright = true
vim.opt.splitbelow = true

vim.opt.list = true
vim.opt.listchars = { tab = "| ", trail = "·", nbsp = "␣" }
