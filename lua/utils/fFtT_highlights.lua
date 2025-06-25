local fFtT_ns = vim.api.nvim_create_namespace("HighlightFMotion")
local incsearchHighlight = vim.api.nvim_get_hl(0, { name = "IncSearch" })
local commentHighlight = vim.api.nvim_get_hl(0, { name = "Comment" })
vim.api.nvim_set_hl(0, "fFtTHighlight", { fg = incsearchHighlight.fg, bg = incsearchHighlight.bg })
vim.api.nvim_set_hl(0, "fFtTBackDrop", { fg = commentHighlight.fg, bg = commentHighlight.bg })

local function clear_fFtT_hl()
	local bufnr = vim.api.nvim_get_current_buf()
	vim.api.nvim_buf_clear_namespace(bufnr, fFtT_ns, 0, -1)
end

local charmap = {
	["<space"] = " ",
	["<lt>"] = "<",
}

local pending_motion = false

local function map_motion_key(motion)
	vim.keymap.set({ "n", "v" }, motion, function()
		clear_fFtT_hl()
		pending_motion = true

		local bufnr = vim.api.nvim_get_current_buf()
		local row, col = unpack(vim.api.nvim_win_get_cursor(0))
		row = row - 1
		local line = vim.api.nvim_buf_get_lines(bufnr, row, row + 1, false)[1]
		if not line then
			return
		end

		local from, to
		if motion == "f" or motion == "t" then
			from, to = col, #line - 1
		elseif motion == "F" or motion == "T" then
			from, to = 0, col
		end

		for i = from, to do
			vim.api.nvim_buf_set_extmark(bufnr, fFtT_ns, row, i, {
				end_col = i + 1,
				hl_group = "fFtTBackDrop",
			})
		end

		local ok, key = pcall(vim.fn.getchar)
		if not ok then
			return
		end

		vim.defer_fn(function()
			pending_motion = false
		end, 100)

		local char
		if type(key) == "number" then
			char = vim.fn.keytrans(vim.fn.nr2char(key)):lower()
		elseif type(key) == "string" then
			char = vim.fn.keytrans(key):lower()
		else
			return
		end

		char = charmap[char] or char

		if char == "<esc>" then
			clear_fFtT_hl()
			return
		end

		for i = from, to do
			if line:sub(i + 1, i + 1) == char then
				vim.api.nvim_buf_set_extmark(bufnr, fFtT_ns, row, i, {
					end_col = i + 1,
					hl_group = "fFtTHighlight",
				})
			end
		end

		vim.api.nvim_feedkeys(motion .. char, "n", true)
	end, { noremap = true })
end

for _, motion in ipairs({ "f", "F", "t", "T" }) do
	map_motion_key(motion)
end

--stylua: ignore
local movement_keys = {
	["h"] = true, ["j"] = true, ["k"] = true, ["l"] = true,
	["w"] = true, ["b"] = true, ["e"] = true,
	["0"] = true, ["^"] = true, ["$"] = true,
	["G"] = true, ["g"] = true,
	["i"] = true, ["a"] = true, ["A"] = true, ["I"] = true,
	["v"] = true, ["V"] = true,
	["<Esc>"] = true,
}

vim.on_key(function(char)
	if pending_motion then
		return
	end

	local mode = vim.fn.mode()
	if mode ~= "n" and mode ~= "v" then
		return
	end

	local key = vim.fn.keytrans(char)
	if movement_keys[key] then
		clear_fFtT_hl()
	end
end, vim.api.nvim_create_namespace("HighlightFMotionKeyWatcher"))
