-- Unbind some redundant keybinds to prevent prevent [G]oto [R]ereferences delay
-- These are already bound using snacks.picker
vim.api.nvim_del_keymap("n", "grr") -- Unbind LSP [G]oto [R]eferences
vim.api.nvim_del_keymap("n", "gri") -- UNbind LSP [G]oto [I]implementation
vim.api.nvim_del_keymap("n", "gra") -- Unbind LSP Code Actions
vim.api.nvim_del_keymap("n", "grn") -- Unbind LSP Rename

vim.keymap.set("n", "<ESC>", ":nohlsearch<CR>", { desc = "Remove Search Highlights" })
local cursorXYGRP = vim.api.nvim_create_augroup("CursorXYGRP", { clear = true })
vim.api.nvim_create_autocmd(
	{ "BufEnter", "WinEnter", "InsertLeave" },
	{ pattern = "*", command = "set cursorline cursorcolumn", group = cursorXYGRP }
)
vim.api.nvim_create_autocmd(
	{ "WinLeave", "InsertEnter" },
	{ pattern = "*", command = "set nocursorline nocursorcolumn", group = cursorXYGRP }
)

vim.keymap.set(
	"n",
	"<leader>H",
	vim.diagnostic.open_float,
	{ noremap = true, silent = true, desc = "Toggle [H]over Diagnostic Float" }
)

vim.keymap.set("n", "<leader>l", function()
	vim.cmd("set number! relativenumber!")
end, { noremap = true, silent = true, desc = "Toggle line numbers" })

-- (Rendered unnecessary by NeoScroll) Center the screen when moving half a page up or down
-- vim.api.nvim_set_keymap("n", "<C-d>", "<C-d>zz", { noremap = true })
-- vim.api.nvim_set_keymap("n", "<C-u>", "<C-u>zz", { noremap = true })

-- Vertical split with <leader>-e
vim.keymap.set("n", "<leader>e", ":vsplit<CR>", { noremap = true, silent = true })
-- Horizontal split with <leader>-o
vim.keymap.set("n", "<leader>o", ":split<CR>", { noremap = true, silent = true })

-- Command-line mappings for history navigation
vim.api.nvim_set_keymap("c", "<C-p>", "<Up>", { noremap = true })
vim.api.nvim_set_keymap("c", "<C-n>", "<Down>", { noremap = true })

vim.keymap.set("n", "J", "mzJ`z")

--vim.keymap.set("n", "<leader>pv", vim.cmd.Ex) -- open netrw
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

vim.keymap.set("n", "]q", ":cnext<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "[q", ":cprevious<CR>", { noremap = true, silent = true })

vim.keymap.set("n", "]t", ":tabnext<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "[t", ":tabprevious<CR>", { noremap = true, silent = true })

vim.keymap.set("n", "<leader>RR", ":checktime<CR>", { noremap = true, silent = true, desc = "[R]efresh buffer" })

vim.keymap.set("n", "<leader>vs", ":Sleuth<CR>", { noremap = true, silent = true, desc = "[V]im [S]leuth" })

-- stylua: ignore
local function setup_tmux_compatible_pane_switching_and_resizing()
	local function move_or_tmux(direction, tmux_cmd)
		local current_win = vim.api.nvim_get_current_win()
		vim.cmd("wincmd " .. direction)
		if current_win == vim.api.nvim_get_current_win() then
			vim.fn.system("tmux select-pane -" .. tmux_cmd)
		end
	end
	vim.keymap.set({"n", "t" }, "<C-h>", function() move_or_tmux("h", "L") end, { noremap = true, silent = true })
	vim.keymap.set({"n", "t" }, "<C-j>", function() move_or_tmux("j", "D") end, { noremap = true, silent = true })
	vim.keymap.set({"n", "t" }, "<C-k>", function() move_or_tmux("k", "U") end, { noremap = true, silent = true })
	vim.keymap.set({"n", "t" }, "<C-l>", function() move_or_tmux("l", "R") end, { noremap = true, silent = true })
	vim.keymap.set({ "n", "i", "v", "t" }, "<A-k>", function() vim.cmd("resize +4") end, { noremap = true, silent = true })
	vim.keymap.set({ "n", "i", "v", "t" }, "<A-j>", function() vim.cmd("resize -4") end, { noremap = true, silent = true })
	vim.keymap.set({ "n", "i", "v", "t" }, "<A-h>", function() vim.cmd("vertical resize -4") end, { noremap = true, silent = true })
	vim.keymap.set({ "n", "i", "v", "t" }, "<A-l>", function() vim.cmd("vertical resize +4") end, { noremap = true, silent = true })
end

setup_tmux_compatible_pane_switching_and_resizing()
