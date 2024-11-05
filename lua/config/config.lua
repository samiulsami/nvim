vim.opt.updatetime = 250
vim.api.nvim_create_augroup("CheckTimeOnCursorHold", { clear = true })
vim.api.nvim_create_autocmd("CursorHold", {
	group = "CheckTimeOnCursorHold",
	pattern = "*",
	command = "checktime",
})

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

vim.schedule(function()
	vim.opt.clipboard = "unnamedplus"
end)
