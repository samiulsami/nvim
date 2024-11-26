vim.opt.updatetime = 50
-- show cursor line only in active window
local cursorGrp = vim.api.nvim_create_augroup("CursorLine", { clear = true })

-- show cursor col line only in active window
local cursorXYGRP = vim.api.nvim_create_augroup("CursorColumn", { clear = true })
vim.api.nvim_create_autocmd(
	{ "InsertLeave", "WinEnter" },
	{ pattern = "*", command = "set cursorcolumn cursorline", group = cursorXYGRP }
)
vim.api.nvim_create_autocmd(
	{ "InsertEnter", "WinLeave" },
	{ pattern = "*", command = "set nocursorcolumn nocursorline", group = cursorXYGRP }
)
vim.g.everforest_enable_italic = true
vim.g.everforest_background = "hard"
vim.g.everforest_better_performance = 1
vim.g.everforest_current_word = "bold"
vim.opt.isfname:append("@-@")
vim.opt.autoread = true
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true
vim.opt.mouse = "a"
vim.opt.grepprg = "rg --vimgrep --no-heading --smart-case"
vim.opt.grepformat = "%f:%l:%m"
vim.opt.cmdheight = 1

vim.schedule(function()
	vim.opt.clipboard = "unnamedplus"
end)
