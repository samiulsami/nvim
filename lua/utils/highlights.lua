---@class highlights
---@field setup_highlight_groups fun(self): nil
---@field show_unique_word_chars fun(self, opts: fFTt_highlights.opts, bufnr: number, row: number, line: string, from: number, to: number, show_all_unique_chars: boolean, show_secondary_chars: boolean): nil
---@field set_backdrop_highlight fun(self, opts: fFTt_highlights.opts, bufnr: number, line: string, char_boundary?: string, row: number, from: number, to: number): nil
---@field set_match_highlight fun(self, opts: fFTt_highlights.opts, utils: utils, bufnr: number, row: number, line: string,  from: number, to: number, char: string): nil
---@field highlight_unique_chars_on_line fun(self, opts: fFTt_highlights.opts): nil
---@field setup_highlight_reset_trigger fun(self, opts: fFTt_highlights.opts): nil
---@field reapply_last_char_highlight fun(self, opts: fFTt_highlights.opts, utils: utils, last_state: last_state, rev: boolean): nil
---@field update_highlighted_lines_info fun(self, start: integer, end: integer): nil
---@field fFtT_ns number
---@field unique_highlight_ns number
---@field hl_line_start integer | nil
---@field hl_line_end integer | nil
---@field backdrop_highlight string
---@field match_highlight string
---@field unique_highlight string
---@field unique_highlight_secondary string
---@field fTfT_highlight_ns number
---@field clear_fFtT_hl fun(self): nil
---@field clear_unique_char_hl fun(self): nil
local highlight_utils = {
	backdrop_highlight = "fFtTBackDropHighlight",
	match_highlight = "fFtTMatchHighlight",
	unique_highlight = "fFtTUniqueHighlight",
	unique_highlight_secondary = "fFtTUniqueHighlightSecondary",
}

function highlight_utils:setup_highlight_groups()
	self.fFtT_ns = vim.api.nvim_create_namespace("highlightFfTtMotion")
	vim.api.nvim_set_hl(0, self.match_highlight, { link = "IncSearch" })
	vim.api.nvim_set_hl(0, self.backdrop_highlight, { link = "Comment" })

	self.unique_highlight_ns = vim.api.nvim_create_namespace("highlightfFtTUniqueChars")
	vim.api.nvim_set_hl(0, self.unique_highlight, { fg = "#bbff99" })
	vim.api.nvim_set_hl(0, self.unique_highlight_secondary, { fg = "#7799ff" })
end

---@param opts fFTt_highlights.opts
function highlight_utils:highlight_unique_chars_on_line(opts)
	self:clear_unique_char_hl()
	local bufnr = vim.api.nvim_get_current_buf()
	local row, col = unpack(vim.api.nvim_win_get_cursor(0))
	row = row - 1
	local line = vim.api.nvim_buf_get_lines(bufnr, row, row + 1, false)[1]
	if not line then
		return
	end
	--stylua: ignore start
	self:show_unique_word_chars(opts, bufnr, row, line, col - 1, math.max(0, col - 1 - opts.line_highlight_radius + 1), opts.show_all_unique_chars == "always", opts.show_unique_secondary_chars == "always")
	self:show_unique_word_chars(opts, bufnr, row, line, col + 1, math.min(vim.fn.strchars(line) - 1, col + 1 + opts.line_highlight_radius - 1), opts.show_all_unique_chars == "always", opts.show_unique_secondary_chars == "always")
	--stlua: ignore end
end

---@param opts fFTt_highlights.opts
---@param utils utils
---@param last_state last_state
---@param rev boolean
function highlight_utils:reapply_last_char_highlight(opts, utils, last_state, rev)
	if vim.fn.reg_executing() ~= "" then
		return
	end
	self:clear_fFtT_hl()
	self.redraw()

	local bufnr = vim.api.nvim_get_current_buf()
	local row, col = unpack(vim.api.nvim_win_get_cursor(0))
	row = row - 1
	local line = vim.api.nvim_buf_get_lines(bufnr, row, row + 1, false)[1]
	if not line then
		return
	end

	local from, to
	if rev then
		from, to = 0, col - 1
	else
		from, to = col + 1, vim.fn.strchars(line) - 1
	end

	if last_state.motion == opts.t or last_state.motion == opts.T then
		if rev then
			to = to - 1
		else
			from = from + 1
		end
	end

	if opts.backdrop then
		self:set_backdrop_highlight(opts, bufnr, line, last_state.char or nil, row, from, to)
		self.redraw()
	end

	local match_count = self:set_match_highlight(opts, utils, bufnr, row, line, from, to, last_state.char)
	if match_count <= 1 then
		self:clear_fFtT_hl()
	end
	self.redraw()
end

---@param opts fFTt_highlights.opts
---@param bufnr integer
---@param line string
---@param char_boundary? string
---@param row integer
---@param from integer
---@param to integer
function highlight_utils:set_backdrop_highlight(opts, bufnr, line, char_boundary, row, from, to)
	local line_len = vim.fn.strchars(line)
	if opts.sticky_highlights then
		from, to =
			math.max(0, from - opts.line_highlight_radius + 1),
			math.min(line_len - 1, to + opts.line_highlight_radius - 1)
	end
	local left, right = from, to
	if left > right then
		left, right = right, left
	end

	if opts.bind_backdrop_border_by_matching_chars and char_boundary then
		local left_boundary, right_boundary = -1, right
		for i = left, right do
			if line:sub(i + 1, i + 1) == char_boundary then
				if left_boundary == -1 then
					left_boundary = i
				end
				right_boundary = i
			end
		end
		left, right = left_boundary, right_boundary
	end

	if opts.backdrop_border_extend then
		left = math.max(0, left - opts.backdrop_border_extend)
		right = math.min(line_len - 1, right + opts.backdrop_border_extend)
	end

	self:update_highlighted_lines_info(row, row + 1)
	for i = left, right do
		vim.api.nvim_buf_set_extmark(bufnr, self.fFtT_ns, row, i, {
			end_col = i + 1,
			hl_group = self.backdrop_highlight,
			priority = 800,
		})
	end
end

---@param opts fFTt_highlights.opts
---@param utils utils
---@param bufnr integer
---@param row integer
---@param line string
---@param from integer
---@param to integer
---@param char string
---@return integer
function highlight_utils:set_match_highlight(opts, utils, bufnr, row, line, from, to, char)
	local line_len = vim.fn.strchars(line)
	if opts.sticky_highlights then
		from, to =
			math.max(0, from - opts.line_highlight_radius + 1),
			math.min(line_len - 1, to + opts.line_highlight_radius - 1)
	end
	self:update_highlighted_lines_info(row, row + 1)
	local match_count = 0
	for i = from, to do
		if utils:char_is_equal(opts, line:sub(i + 1, i + 1), char) then
			match_count = match_count + 1
			vim.api.nvim_buf_set_extmark(bufnr, self.fFtT_ns, row, i, {
				end_col = i + 1,
				hl_group = self.match_highlight,
				priority = 900,
			})
		end
	end
	return match_count
end

function highlight_utils:update_highlighted_lines_info(start, end_)
	if not self.hl_line_start then
		self.hl_line_start = start
	end
	if not self.hl_line_end then
		self.hl_line_end = end_
	end
	self.hl_line_start = math.min(self.hl_line_start, start)
	self.hl_line_end = math.max(self.hl_line_end, end_)
end

function highlight_utils:clear_unique_char_hl()
	local bufnr = vim.api.nvim_get_current_buf()
	vim.api.nvim_buf_clear_namespace(bufnr, self.unique_highlight_ns, self.hl_line_start or 0, self.hl_line_end or -1)
end

highlight_utils.redraw = function()
	vim.schedule(function()
		vim.cmd("redraw")
	end)
end

function highlight_utils:clear_fFtT_hl()
	local bufnr = vim.api.nvim_get_current_buf()
	vim.api.nvim_buf_clear_namespace(bufnr, self.fFtT_ns, self.hl_line_start or 0, self.hl_line_end or -1)
	self.hl_line_start = nil
	self.hl_line_end = nil
end

---@param opts fFTt_highlights.opts
---@param bufnr integer
---@param row integer
---@param line string
---@param from integer
---@param to integer
---@param show_all_unique_chars boolean
---@param show_secondary_chars boolean
function highlight_utils:show_unique_word_chars(
	opts,
	bufnr,
	row,
	line,
	from,
	to,
	show_all_unique_chars,
	show_secondary_chars
)
	if opts.show_unique_word_chars == "never" then
		return
	end
	local inc = 1
	if from > to then
		inc = -1
	end

	local line_len = vim.fn.strchars(line)
	self:update_highlighted_lines_info(row, row + 1)
	local seen = {}
	local word_ended = true
	local word_ended_secondary = true

	for i = from, to, inc do
		local char = line:sub(i + 1, i + 1)
		if opts.case_sensitivity ~= "default" then
			char = char:lower()
		end

		if not seen[char] then
			seen[char] = 1
			if i < line_len and (show_all_unique_chars or word_ended) then
				word_ended = false
				vim.api.nvim_buf_set_extmark(bufnr, self.unique_highlight_ns, row, i, {
					end_col = i + 1,
					hl_group = self.unique_highlight,
					priority = 1100,
				})
			end
		elseif show_secondary_chars and seen[char] == 1 then
			seen[char] = 2
			if i < line_len and (show_all_unique_chars or word_ended_secondary) then
				word_ended_secondary = false
				vim.api.nvim_buf_set_extmark(bufnr, self.unique_highlight_ns, row, i, {
					end_col = i + 1,
					hl_group = self.unique_highlight_secondary,
					priority = 1000,
				})
			end
		end

		if vim.fn.match(char, "\\k") == -1 or char == "_" or char == "-" then
			word_ended = true
			word_ended_secondary = true
		elseif i + inc < line_len then
			local char2 = line:sub(i + 1 + inc, i + 1 + inc)
			if (char == char:lower()) ~= (char2 == char2:lower()) then
				word_ended = true
				word_ended_secondary = true
			end
		end
	end
end

return highlight_utils
