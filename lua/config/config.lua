vim.keymap.set({ "n", "v" }, "Q", "<nop>", { noremap = true, silent = true })
vim.keymap.set({ "n", "v" }, "gQ", "<nop>", { noremap = true, silent = true })

vim.opt.updatetime = 50
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.splitright = true
vim.opt.splitbelow = true

vim.opt.showmode = false
vim.opt.breakindent = true
vim.opt.linebreak = true
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.expandtab = true
vim.opt.wrap = false
vim.opt.inccommand = "split"
vim.opt.cursorcolumn = true
vim.opt.cursorline = true

vim.g.conceallevel = 0
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.o.confirm = true

-- Disable jumplist persistence across sessions
-- Default is: !,'100,<50,s10,h
vim.opt.shada = "!,'0,<50,s10,h"

local cursorXYGRP = vim.api.nvim_create_augroup("CursorXYGRP", { clear = true })
vim.api.nvim_create_autocmd(
	{ "InsertLeave", "WinEnter" },
	{ pattern = "*", command = "set cursorline cursorcolumn", group = cursorXYGRP }
)

vim.api.nvim_create_autocmd(
	{ "InsertEnter", "WinLeave" },
	{ pattern = "*", command = "set nocursorline nocursorcolumn", group = cursorXYGRP }
)

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
vim.o.sessionoptions = "buffers,folds,help,tabpages,winsize,winpos"
vim.opt.cmdheight = 0

-- Fix corrupted neovim content after tmux pane/session switch.
-- :mode calls screenclear() before redrawing (unlike redraw! which skips the clear),
-- so old terminal content doesn't bleed through transparent highlight groups.
-- Requires 'focus-events on' in tmux.conf (set).
vim.api.nvim_create_autocmd("FocusGained", {
	callback = function()
		vim.cmd.mode()
	end,
})

vim.schedule(function()
	vim.opt.clipboard = "unnamedplus"
end)
