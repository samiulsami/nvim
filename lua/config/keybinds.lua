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

vim.keymap.set("n", "<esc>", function()
	vim.cmd("nohlsearch")
	return "<esc>"
end, { expr = true, desc = "Remove Search Highlights" })

vim.keymap.set(
	"n",
	"H",
	vim.diagnostic.open_float,
	{ noremap = true, silent = true, desc = "Toggle [H]over Diagnostic Float" }
)

vim.keymap.set("n", "zf", "za", { noremap = true, silent = true, desc = "Toggle fold at cursor" })

vim.keymap.set("n", "]d", function()
	local ok, err = pcall(vim.diagnostic.jump, {
		count = 1,
		on_jump = function(_, bufnr)
			vim.diagnostic.open_float({ bufnr = bufnr, scope = "cursor", focus = false })
		end,
	})
	if not ok then
		vim.notify("Diagnostic error: " .. vim.inspect(err), vim.log.levels.ERROR)
	end
end, { noremap = true, silent = true, desc = "Jump to next Diagnostic" })

vim.keymap.set("n", "[d", function()
	local ok, err = pcall(vim.diagnostic.jump, {
		count = -1,
		on_jump = function(_, bufnr)
			vim.diagnostic.open_float({ bufnr = bufnr, scope = "cursor", focus = false })
		end,
	})
	if not ok then
		vim.notify("Diagnostic error: " .. vim.inspect(err), vim.log.levels.ERROR)
	end
end, { noremap = true, silent = true, desc = "Jump to previous Diagnostic" })

vim.keymap.set("n", "<leader>l", function()
	vim.cmd("set number! relativenumber!")
end, { noremap = true, silent = true, desc = "Toggle line numbers" })

vim.keymap.set("n", "<C-d>", "<C-d>zz", { noremap = true })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { noremap = true })

-- Vertical split with <leader>-e
vim.keymap.set("n", "<leader>e", "<Cmd>vsplit<CR>", { noremap = true, silent = true })
-- Horizontal split with <leader>-o
vim.keymap.set("n", "<leader>o", "<Cmd>split<CR>", { noremap = true, silent = true })

vim.keymap.set("n", "<leader>O", "<C-w>o", { desc = ":Only", noremap = true, silent = true })

vim.keymap.set("n", "<leader>Q", "<Cmd>q!<CR>", { desc = "force quit", noremap = true, silent = true })
vim.keymap.set("n", "<leader>q", "<Cmd>q<CR>", { desc = "quit", noremap = true, silent = true })
vim.keymap.set("n", "<leader>w", function()
	vim.cmd("w")
	vim.notify("Saved current buffer", vim.log.levels.INFO)
end, { desc = "Save current buffer", noremap = true, silent = true })

vim.keymap.set("n", "<leader>W", function()
	vim.cmd("wa")
	vim.notify("Saved all buffers", vim.log.levels.INFO)
end, { desc = "Save all buffers", noremap = true, silent = true })

-- Command-line mappings for history navigation
vim.keymap.set("c", "<C-p>", "<Up>", { noremap = true })
vim.keymap.set("c", "<C-n>", "<Down>", { noremap = true })

vim.keymap.set("n", "J", "mzJ`z")
vim.keymap.set("v", "p", '"_dP')

--vim.keymap.set("n", "<leader>pv", vim.cmd.Ex) -- open netrw
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

vim.keymap.set("n", "]q", "<Cmd>cnext<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "[q", "<Cmd>cprevious<CR>", { noremap = true, silent = true })

vim.keymap.set("n", "]t", "<Cmd>tabnext<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "[t", "<Cmd>tabprevious<CR>", { noremap = true, silent = true })

local seen_buffers = {}
local prev_direction = nil

local function jump_to_different_file(direction)
	if direction ~= prev_direction then
		seen_buffers = {}
		prev_direction = direction
	end
	local step = direction == "next" and 1 or -1
	table.insert(seen_buffers, vim.api.nvim_get_current_buf())

	local jumplist_data = vim.fn.getjumplist(vim.api.nvim_get_current_win())
	local jumplist = jumplist_data[1]
	local initial_pos = jumplist_data[2]
	local i = initial_pos + step

	while i >= 0 and i < #jumplist do
		local jump = jumplist[i + 1]
		if jump and not vim.tbl_contains(seen_buffers, jump.bufnr) and vim.api.nvim_buf_is_valid(jump.bufnr) then
			vim.cmd(
				"normal! "
					.. math.abs(i - initial_pos)
					.. vim.api.nvim_replace_termcodes(direction == "next" and "<C-i>" or "<C-o>", true, false, true)
			)
			table.insert(seen_buffers, jump.bufnr)
			return
		end
		i = i + step
	end
end

vim.keymap.set("n", "<C-n>", function()
	jump_to_different_file("next")
end, { noremap = true, silent = true, desc = "Jump to next file in jump list" })
vim.keymap.set("n", "<C-p>", function()
	jump_to_different_file("previous")
end, { noremap = true, silent = true, desc = "Jump to previous file in jump list" })
vim.keymap.set("n", "<leader>cj", function()
	vim.cmd("clearjumps")
	vim.notify("Cleared jump list", vim.log.levels.INFO)
end, { silent = true, noremap = true, desc = "Clear jump list" })

vim.keymap.set("n", "<c-w>h", "<c-w>H", { desc = "Move window left", noremap = true, silent = true })
vim.keymap.set("n", "<c-w>j", "<c-w>J", { desc = "Move window down", noremap = true, silent = true })
vim.keymap.set("n", "<c-w>k", "<c-w>K", { desc = "Move window up", noremap = true, silent = true })
vim.keymap.set("n", "<c-w>l", "<c-w>L", { desc = "Move window right", noremap = true, silent = true })

vim.keymap.set("n", "<leader>R", function()
	vim.cmd("checktime")
	vim.notify("[Refreshed buffer]", vim.log.levels.INFO)
end, { noremap = true, silent = true, desc = "Refresh buffer" })

vim.keymap.set("t", "<esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

vim.api.nvim_create_autocmd({
	"TermEnter",
}, { pattern = "*", command = "set number" })

vim.keymap.set("n", "<leader>T", function()
	local dir = vim.fn.expand("%:p:h")
	local result = vim.fn.system({ "tmux", "split-window", "-c", dir })
	if vim.v.shell_error ~= 0 then
		vim.notify("Failed to open tmux split: " .. result, vim.log.levels.ERROR)
		return
	end
end, { noremap = true, silent = true, desc = "Open a horizontal tmux split on current buffer's directory" })

-- slightly less strict than "gx"
vim.keymap.set("n", "<leader>B", function()
	local curPosXY = vim.api.nvim_win_get_cursor(0)
	local cursorPosition = curPosXY[2]
	local line = vim.api.nvim_get_current_line()

	local pattern = [[\v((https?://)?[a-zA-Z0-9.-]+\.[a-zA-Z]{2,})(/[a-zA-Z0-9._~:/?#@!$&'()*+,;=%-]*)?]]

	local closest_url = ""

	local pos = 0
	while pos < #line do
		local matchData = vim.fn.matchstrpos(line, pattern, pos)
		local url = matchData[1]
		local start = matchData[2]
		local end_ = matchData[3]

		if url == "" or start < 0 then
			break
		end

		if start <= cursorPosition and end_ > cursorPosition then
			closest_url = url
			break
		end

		pos = end_ + 1
	end

	if closest_url == "" then
		vim.notify("No URL found under cursor", vim.log.levels.WARN)
		return
	end

	if not closest_url:match("^https?://") then
		closest_url = "https://" .. closest_url
	end

	local modified_url = vim.fn.input("Confirm url: ", closest_url)
	if modified_url == "" then
		return
	end

	vim.ui.open(modified_url)
end, { desc = "Open the URL under cursor in a browser with vim.ui.open" })
