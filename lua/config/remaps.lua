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
--vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

vim.keymap.set("n", "<C-Up>", ":resize +2<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<C-Down>", ":resize -2<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<C-Left>", ":vertical resize -2<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<C-Right>", ":vertical resize +2<CR>", { noremap = true, silent = true })

vim.keymap.set("n", "<leader>gm", ":Git mergetool<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>lr", ":LspRestart<CR>", { noremap = true, silent = true })

-- Function to copy the file path relative to the project root, enclosed in quotes
function Copy_project_relative_path()
	-- Get the full path of the current file
	local file_path = vim.fn.expand("%:p")

	-- Remove $HOME from the path if present
	local home_dir = vim.fn.getenv("HOME")
	if home_dir and file_path:find("^" .. home_dir) then
		file_path = file_path:gsub("^" .. vim.fn.escape(home_dir, "/"), "")
	end

	-- Split the file path into segments
	local segments = {}
	for segment in string.gmatch(file_path, "[^/]+") do
		table.insert(segments, segment)
	end

	-- Identify the project name (last segment)
	local project_name = segments[#segments] -- Last segment is considered the project name

	-- Print the identified project directory
	print("Identified project directory: " .. project_name)

	-- Build the path from the project directory to the file
	-- This will start from the first segment and include everything from there
	local relative_path = table.concat(segments, "/", #segments - #segments + 1)

	-- Print the path from the project root to the focused file
	print("Path from project root to file: " .. relative_path)

	-- Copy the path to clipboard
	local quoted_path = '"' .. relative_path .. '"'
	vim.fn.setreg("+", quoted_path)
	print("Copied path: " .. quoted_path)

	return relative_path -- Return the final relative path
end
-- Map <leader>ci to call the function
vim.api.nvim_set_keymap("n", "<leader>ci", ":lua Copy_project_relative_path()<CR>", { noremap = true, silent = true })
