-- Unbind some redundant keybinds to prevent prevent [G]oto [R]ereferences delay
-- These are already bound using telescope
vim.api.nvim_del_keymap("n", "grr") -- Unbind LSP [G]oto [R]eferences
vim.api.nvim_del_keymap("n", "gri") -- UNbind LSP [G]oto [I]implementation
vim.api.nvim_del_keymap("n", "gra") -- Unbind LSP Code Actions
vim.api.nvim_del_keymap("n", "grn") -- Unbind LSP Rename

vim.keymap.set(
	"n",
	"<leader>h",
	vim.diagnostic.open_float,
	{ noremap = true, silent = true, desc = "Toggle [H]over Diagnostic Float" }
)

vim.keymap.set("n", "<F7>", function()
	vim.cmd("set number! relativenumber!")
end, { noremap = true, silent = true, desc = "Toggle line numbers" })

-- Center the screen when moving half a page up or down
vim.api.nvim_set_keymap("n", "<C-d>", "<C-d>zz", { noremap = true })
vim.api.nvim_set_keymap("n", "<C-u>", "<C-u>zz", { noremap = true })

-- Remap window navigation keys
vim.api.nvim_set_keymap("n", "<C-h>", "<C-w>h", { noremap = true })
vim.api.nvim_set_keymap("n", "<C-j>", "<C-w>j", { noremap = true })
vim.api.nvim_set_keymap("n", "<C-k>", "<C-w>k", { noremap = true })
vim.api.nvim_set_keymap("n", "<C-l>", "<C-w>l", { noremap = true })

-- Vertical split with alt-e
vim.keymap.set("n", "<leader><A-e>", ":vsplit<CR>", { noremap = true, silent = true })
-- Horizontal split with alt-o
vim.keymap.set("n", "<leader><A-o>", ":split<CR>", { noremap = true, silent = true })

-- Command-line mappings for history navigation
vim.api.nvim_set_keymap("c", "<C-p>", "<Up>", { noremap = true })
vim.api.nvim_set_keymap("c", "<C-n>", "<Down>", { noremap = true })

vim.keymap.set("n", "J", "mzJ`z")

vim.keymap.set("x", "p", [["_dP]]) -- paste without overwriting the register
vim.keymap.set("x", "<leader>p", "p") -- paste and overwrite the register

--vim.keymap.set("n", "<leader>pv", vim.cmd.Ex) -- open netrw
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

vim.keymap.set("n", "<C-Up>", ":resize +4<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<C-Down>", ":resize -4<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<C-Left>", ":vertical resize -4<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<C-Right>", ":vertical resize +4<CR>", { noremap = true, silent = true })

vim.keymap.set("n", "]q", ":cnext<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "[q", ":cprevious<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>RL", ":LspRestart<CR>", { noremap = true, silent = true, desc = "[R]efresh [L]sp" })

vim.keymap.set("n", "<leader>vs", ":Sleuth<CR>", { noremap = true, silent = true, desc = "[V]im [S]leuth" })
