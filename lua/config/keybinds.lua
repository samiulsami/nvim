vim.api.nvim_del_keymap("n", "grr") -- Unbind LSP [G]oto [R]eferences
vim.api.nvim_del_keymap("n", "gri") -- UNbind LSP [G]oto [I]implementation
vim.api.nvim_del_keymap("n", "gra") -- Unbind LSP Code Actions
vim.api.nvim_del_keymap("n", "grn") -- Unbind LSP Rename
vim.keymap.set("n", "L", "")

vim.keymap.set("n", "<leader>cp", function()
	local directory_path = vim.fn.expand("%:p:h")
	vim.fn.setreg("+", '"' .. directory_path .. '"')
	vim.notify("'" .. directory_path .. "'\ncopied to clipboard", vim.log.levels.INFO)
end, { noremap = true, silent = true, desc = "[C]opy [P]ath to current file directory" })

vim.keymap.set("n", "<leader>cP", function()
	local current_file_path = vim.fn.expand("%:p")
	vim.fn.setreg("+", '"' .. current_file_path .. '"')
	vim.notify("'" .. current_file_path .. "'\ncopied to clipboard", vim.log.levels.INFO)
end, { noremap = true, silent = true, desc = "[C]opy [P]ath to current file" })

vim.keymap.set("n", "<ESC>", function()
	vim.cmd("nohlsearch")
	vim.g.lualine_show_search_index = false
	local ok, lualine = pcall(require, "lualine")
	if ok then
		lualine.refresh()
	end
	return "<ESC>"
end, { expr = true, desc = "Remove Search Highlights" })

vim.keymap.set("n", "s", "/", { silent = true, desc = "Search [/]" })

vim.keymap.set(
	"n",
	"H",
	vim.diagnostic.open_float,
	{ noremap = true, silent = true, desc = "Toggle [H]over Diagnostic Float" }
)

vim.keymap.set("n", "]d", function()
	local ok, err = pcall(vim.diagnostic.jump, { count = 1, float = true })
	if not ok then
		vim.notify("Diagnostic error: " .. vim.inspect(err), vim.log.levels.ERROR)
	end
end, { noremap = true, silent = true, desc = "Jump to next Diagnostic" })

vim.keymap.set("n", "[d", function()
	local ok, err = pcall(vim.diagnostic.jump, { count = -1, float = true })
	if not ok then
		vim.notify("Diagnostic error: " .. vim.inspect(err), vim.log.levels.ERROR)
	end
end, { noremap = true, silent = true, desc = "Jump to previous Diagnostic" })

vim.keymap.set("n", "<leader>l", function()
	vim.cmd("set number! relativenumber!")
end, { noremap = true, silent = true, desc = "Toggle line numbers" })

vim.api.nvim_set_keymap("n", "<C-d>", "<C-d>zz", { noremap = true })
vim.api.nvim_set_keymap("n", "<C-u>", "<C-u>zz", { noremap = true })

-- Vertical split with <leader>-e
vim.keymap.set("n", "<leader>e", "<Cmd>vsplit<CR>", { noremap = true, silent = true })
-- Horizontal split with <leader>-o
vim.keymap.set("n", "<leader>o", "<Cmd>split<CR>", { noremap = true, silent = true })

vim.keymap.set("n", "<leader>O", "<C-w>o", { desc = ":Only", noremap = true, silent = true })

vim.keymap.set("n", "<leader>Q", "<Cmd>qa!<CR>", { desc = "quit all", noremap = true, silent = true })
vim.keymap.set("n", "<leader>q", "<Cmd>wqa!<CR>", { desc = "save and quit all", noremap = true, silent = true })
vim.keymap.set("n", "<leader>w", function()
	vim.cmd("wa!")
	vim.notify("Saved all", vim.log.levels.INFO)
end, { desc = "save all", noremap = true, silent = true })

-- Command-line mappings for history navigation
vim.api.nvim_set_keymap("c", "<C-p>", "<Up>", { noremap = true })
vim.api.nvim_set_keymap("c", "<C-n>", "<Down>", { noremap = true })

vim.keymap.set("n", "J", "mzJ`z")
vim.keymap.set("v", "p", '"_dP')

--vim.keymap.set("n", "<leader>pv", vim.cmd.Ex) -- open netrw
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

vim.keymap.set("n", "]q", "<Cmd>cnext<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "[q", "<Cmd>cprevious<CR>", { noremap = true, silent = true })

vim.keymap.set("n", "]t", "<Cmd>tabnext<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "[t", "<Cmd>tabprevious<CR>", { noremap = true, silent = true })

vim.keymap.set("n", "<c-w>h", "<c-w>H", { desc = "Move window left", noremap = true, silent = true })
vim.keymap.set("n", "<c-w>j", "<c-w>J", { desc = "Move window down", noremap = true, silent = true })
vim.keymap.set("n", "<c-w>k", "<c-w>K", { desc = "Move window up", noremap = true, silent = true })
vim.keymap.set("n", "<c-w>l", "<c-w>L", { desc = "Move window right", noremap = true, silent = true })

vim.keymap.set("n", "<leader>RR", "<Cmd>checktime<CR>", { noremap = true, silent = true, desc = "[R]efresh buffer" })

local function move_or_tmux(direction, tmux_cmd)
	local current_win = vim.api.nvim_get_current_win()
	vim.cmd("wincmd " .. direction)
	if current_win == vim.api.nvim_get_current_win() then
		vim.fn.system("tmux select-pane -" .. tmux_cmd)
	end
end
vim.keymap.set({ "n", "t" }, "<C-h>", function()
	move_or_tmux("h", "L")
end, { noremap = true, silent = true })
vim.keymap.set({ "n", "t" }, "<C-j>", function()
	move_or_tmux("j", "D")
end, { noremap = true, silent = true })
vim.keymap.set({ "n", "t" }, "<C-k>", function()
	move_or_tmux("k", "U")
end, { noremap = true, silent = true })
vim.keymap.set({ "n", "t" }, "<C-l>", function()
	move_or_tmux("l", "R")
end, { noremap = true, silent = true })

vim.keymap.set({ "n", "i", "v", "t" }, "<A-k>", function()
	vim.cmd("resize +4")
end, { noremap = true, silent = true })
vim.keymap.set({ "n", "i", "v", "t" }, "<A-j>", function()
	vim.cmd("resize -4")
end, { noremap = true, silent = true })
vim.keymap.set({ "n", "i", "v", "t" }, "<A-h>", function()
	vim.cmd("vertical resize -4")
end, { noremap = true, silent = true })
vim.keymap.set({ "n", "i", "v", "t" }, "<A-l>", function()
	vim.cmd("vertical resize +4")
end, { noremap = true, silent = true })

vim.keymap.set("t", "<ESC>", "<C-\\><C-n>", { desc = "Exit terminal mode" })
vim.api.nvim_create_autocmd({
	"TermEnter",
}, { pattern = "*", command = "set number" })
