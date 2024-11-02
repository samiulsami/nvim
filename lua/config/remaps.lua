vim.api.nvim_set_keymap("n", "<F7>", ":set relativenumber!<CR>", { noremap = true, silent = true })

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
vim.keymap.set("x", "<leader>p", '"_dP')
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

vim.keymap.set("n", "<C-Up>", ":resize +2<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<C-Down>", ":resize -2<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<C-Left>", ":vertical resize -2<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<C-Right>", ":vertical resize +2<CR>", { noremap = true, silent = true })


vim.keymap.set("n", "<leader>gm", ":Git mergetool<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>lr", ":LspRestart<CR>", { noremap = true, silent = true })
