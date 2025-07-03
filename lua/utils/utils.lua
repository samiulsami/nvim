---@class utils
---@field get_char fun(self): string | nil
---@field char_is_equal fun(self, opts: fFTt_highlights.opts, string_char: string, typed_char: string): boolean
---@field valid_input_char fun(self, opts: fFTt_highlights.opts, string_char: string, motion: string): boolean
---@field disabled_file_or_buftype fun(self, opts: fFTt_highlights.opts): boolean
---@field charmap table<string, string>
local utils = {
	charmap = { --HACK:
		["<space>"] = " ",
		["<lt>"] = "<",
	},
}

---@return string | nil
function utils:get_char()
	local ok, key = pcall(vim.fn.getcharstr)
	if not ok then
		return nil
	end

	local char = vim.fn.keytrans(key)
	return self.charmap[char:lower()] or char
end

---@param opts fFTt_highlights.opts
---@param string_char string
---@param typed_char string
---@return boolean
function utils:char_is_equal(opts, string_char, typed_char)
	if opts.case_sensitivity == "default" then
		return string_char == typed_char
	end

	if opts.case_sensitivity == "smart" then
		if typed_char == typed_char:lower() then
			return typed_char:lower() == string_char:lower()
		end
		return string_char == typed_char
	end

	return string_char == typed_char
end

---@param opts fFTt_highlights.opts
---@param char string
---@param motion string
---@return boolean
function utils:valid_input_char(opts, char, motion)
	if not char or char == opts.reset_key then
		return false
	end
	local bufnr = vim.api.nvim_get_current_buf()
	local row, col = unpack(vim.api.nvim_win_get_cursor(0))
	row = row - 1
	local line = vim.api.nvim_buf_get_lines(bufnr, row, row + 1, false)[1]
	if not line then
		return false
	end

	local from, to
	if motion == opts.f or motion == opts.t then
		from, to = col, math.min(vim.fn.strchars(line) - 1, col + opts.line_highlight_radius - 1)
	elseif motion == opts.F or motion == opts.T then
		from, to = math.max(0, col - opts.line_highlight_radius + 1), col
	end

	for i = from, to do
		if self:char_is_equal(opts, line:sub(i + 1, i + 1), char) then
			return true
		end
	end
	return false
end

---@param opts fFTt_highlights.opts
---@return boolean
function utils:disabled_file_or_buftype(opts)
	if vim.tbl_contains(opts.disabled_filetypes, vim.bo.filetype) then
		return true
	end
	return vim.tbl_contains(opts.disabled_buftypes, vim.bo.buftype)
end

return utils
