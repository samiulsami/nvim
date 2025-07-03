---@class fFTt_highlights.opts
---@field public f string | nil f key. default: "f"
---@field public F string | nil F key. default: "F"
---@field public t string | nil t key. default: "t"
---@field public T string | nil T key. default: "T"
---@field public next string | nil next key. default: ";"
---@field public prev string | nil previous key. default: ","
---@field public repeat_key string | nil repeat key. default: "."
---@field public reset_key string | nil escape key. default: "<Esc>"
---@field public case_sensitivity "default" | "smart" | "none" | nil case sensitivity. default: "default"
---@field public show_unique_word_chars "on_key_press" | "always" | "never" | nil whether to show unique characters. default: "never"
---@field public show_unique_secondary_chars "on_key_press" | "always" | "never" | nil whether to show secondary unique characters. default: "never"
---@field public show_all_unique_chars "on_key_press" | "always" | "never" | nil whether to show all unique characters. default: "never"
---@field public backdrop boolean | nil whether to show backdrop. default: "true"
---@field public bind_backdrop_border_by_matching_chars boolean | nil whether to bind backdrop radius by matching characters. default: true
---@field public backdrop_border_extend integer | nil extend backdrop border by this many characters. default: "1"
---@field public sticky_highlights boolean | nil whether to highlight matches that have been skipped over. default: false
---@field public disabled_filetypes table<string> | nil disable highlighting for these filetypes
---@field public disabled_buftypes table<string> | nil disable highlighting for these buftypes
---@field public line_highlight_radius integer | nil highlight this many characters around the cursor. default: 500
---@field public smart_motions boolean | nil whether to use f/F/t/T to go to next/previous characters. default: false

---@class last_state
---@field motion string
---@field char string

---@class ffTt_highlights
---@field public opts fFTt_highlights.opts
---@field public fFtT_action fun(): nil
---@field public next_prev_action fun(): nil
---@field public setup fun(self, opts?: fFTt_highlights.opts): nil
---@field private smart_action fun(self, opts: fFTt_highlights.opts, motion: string): nil
---@field private validate_opts fun(self, opts: fFTt_highlights.opts): nil
---@field private move_cursor_to_char fun(self, opts: fFTt_highlights.opts, line: string, motion: string, char: string, row: number, col: number, reverse: boolean): integer | nil
---@field private set_backdrop fun(self): nil
---@field private motion_escape_sequence fun(self): nil
---@field private in_motion boolean
---@field private last_state last_state | nil
---@field private setup_done boolean
---@field private current_motion string | nil
---@field private highlights highlights
---@field private utils utils
local fFtT_hl = {
	in_motion = false,
	setup_done = false,
}

---@type fFTt_highlights.opts
local default_opts = {
	f = "f",
	F = "F",
	t = "t",
	T = "T",
	next = ";",
	prev = ",",
	repeat_key = ".",
	reset_key = "<Esc>",
	smart_motions = false,
	case_sensitivity = "default",
	sticky_highlights = false,
	backdrop = true,
	show_unique_word_chars = "never",
	show_unique_secondary_chars = "never",
	show_all_unique_chars = "never",
	backdrop_border_extend = 1,
	bind_backdrop_border_by_matching_chars = true,
	line_highlight_radius = 500,
	disabled_filetypes = {},
	disabled_buftypes = {},
}

---@param opts? fFTt_highlights.opts
function fFtT_hl:setup(opts)
	if self.setup_done then
		return
	end
	opts = opts or {}
	opts = vim.tbl_deep_extend("force", default_opts, opts)
	self:validate_opts(opts)

	_G.fFtT_hl = fFtT_hl

	self.highlights = require("utils.highlights")
	self.utils = require("utils.utils")

	self.opts = opts
	self.setup_done = true

	self.highlights:setup_highlight_groups()
	self:setup_highlight_reset_trigger(opts)
	for _, motion in ipairs({ opts.f, opts.F, opts.t, opts.T }) do
		self.current_motion = motion
		for _, mode in ipairs({ "n", "x" }) do
			vim.keymap.set(mode, motion, function()
				if self.opts.smart_motions and self.in_motion and self.last_state then
					return fFtT_hl:smart_action(self.opts, motion)
				end
				self.current_motion = motion
				self:set_backdrop()
				self.saved_char = self.utils:get_char()
				if not self.utils:valid_input_char(self.opts, self.saved_char, self.current_motion) then
					self:motion_escape_sequence()
					return opts.reset_key
				end
				self:fFtT_action()
			end, { expr = false })
		end

		vim.keymap.set("o", motion, function()
			self.current_motion = motion
			self:set_backdrop()
			self.saved_char = self.utils:get_char()
			if not self.utils:valid_input_char(self.opts, self.saved_char, self.current_motion) then
				self:motion_escape_sequence()
				return opts.reset_key
			end
			return "v<Cmd>lua fFtT_hl.fFtT_action()<CR>"
		end, { expr = true })
	end

	for _, motion in ipairs({ opts.next, opts.prev }) do
		if motion ~= "" then
			for _, mode in ipairs({ "n", "x" }) do
				vim.keymap.set(mode, motion, function()
					self.current_motion = motion
					self:next_prev_action()
				end, { expr = false })
			end
			vim.keymap.set("o", motion, function()
				self.current_motion = motion
				return "v<Cmd>lua fFtT_hl.next_prev_action()<CR>"
			end, { expr = true })
		end
	end

	local fFtT_hl_clear_group = vim.api.nvim_create_augroup("fFtTHLClearGroup", { clear = true })
	vim.api.nvim_create_autocmd("InsertEnter", {
		group = fFtT_hl_clear_group,
		callback = function()
			self.in_motion = false
			self.highlights:clear_unique_char_hl()
			self.highlights:clear_fFtT_hl()
			self.highlights:clear_unique_char_hl()
			self.highlights.redraw()
		end,
	})

	if opts.show_unique_word_chars == "always" then
		vim.api.nvim_create_autocmd("CursorMoved", {
			group = fFtT_hl_clear_group,
			callback = function()
				self.highlights:highlight_unique_chars_on_line(opts)
				self.highlights.redraw()
			end,
		})
	end
end

---@param opts fFTt_highlights.opts
function fFtT_hl:validate_opts(opts)
	--stylua: ignore start
	if opts.backdrop_border_extend and opts.backdrop_border_extend < 0 then
		error("opts.extended_backdrop_borders must be >= 0")
	end
	if opts.line_highlight_radius < 1 then
		error("opts.line_highlight_radius must be >= 1")
	end
	if opts.case_sensitivity ~= "default" and opts.case_sensitivity ~= "smart" and opts.case_sensitivity ~= "none" then
		error("opts.case_sensitivity must be one of 'default', 'smart' or 'none'")
	end
	if opts.show_unique_word_chars ~= "always" and opts.show_unique_word_chars ~= "never" and opts.show_unique_word_chars ~= "on_key_press" then
		error("opts.show_unique_word_chars must be one of 'always', 'never' or 'on_key_press'")
	end
	if opts.show_all_unique_chars ~= "always" and opts.show_all_unique_chars ~= "never" and opts.show_all_unique_chars ~= "on_key_press" then
		error("opts.show_all_unique_chars must be one of 'always', 'never' or 'on_key_press'")
	end
	if opts.show_unique_secondary_chars ~= "always" and opts.show_unique_secondary_chars ~= "never" and opts.show_unique_secondary_chars ~= "on_key_press" then
		error("opts.show_unique_secondary_chars must be one of 'always', 'never' or 'on_key_press'")
	end
	--stylua: ignore end
end

function fFtT_hl:motion_escape_sequence()
	self.in_motion = false
	self.highlights:clear_fFtT_hl()
	self.highlights:clear_unique_char_hl()
	if self.opts.show_unique_word_chars == "always" then
		self.highlights:highlight_unique_chars_on_line(self.opts)
	end
	self.highlights.redraw()
end

---@param opts fFTt_highlights.opts
---@param line string
---@param motion string
---@param char string
---@param row integer
---@param col integer
---@param reverse boolean
---@return integer | nil
function fFtT_hl:move_cursor_to_char(opts, line, motion, char, row, col, reverse)
	local line_len = vim.fn.strchars(line)
	if col > line_len or col < 0 then
		return nil
	end
	local match_pos = nil
	local from, to = col + 1, math.min(line_len - 1, col + 1 + opts.line_highlight_radius - 1)
	if reverse then
		from, to = math.max(0, col - 1 - opts.line_highlight_radius + 1), col - 1
	end

	--stylua: ignore start
	if motion == opts.t or motion == opts.T then
		if reverse then to = math.max(0, to - 1)
		else from = math.min(line_len - 1, from + 1) end
	end

	if from > to then from, to = to, from end

	if reverse then
		for i = to, from, -1 do
			if self.utils:char_is_equal(opts, line:sub(i + 1, i + 1), char) then match_pos = i break end
		end
	else
		for i = from, to do
			if self.utils:char_is_equal(opts, line:sub(i + 1, i + 1), char) then match_pos = i break end
		end
	end

	if match_pos and (motion == opts.T or motion == opts.t) then
		if reverse then match_pos = math.min(line_len - 1, match_pos + 1)
		else match_pos = math.max(0, match_pos - 1) end
	end

	if match_pos and match_pos >= 0 and match_pos < line_len then
		vim.api.nvim_win_set_cursor(0, { row + 1, match_pos })
		return match_pos
	end
	--stylua: ignore end

	return nil
end

---@param opts fFTt_highlights.opts
function fFtT_hl:setup_highlight_reset_trigger(opts)
	local highlights = self.highlights
	vim.on_key(function(_, typed_key)
		if self.utils:disabled_file_or_buftype(opts) then
			return
		end

		typed_key = vim.fn.keytrans(typed_key)
		if typed_key == opts.reset_key then
			self.in_motion = false
			highlights:clear_fFtT_hl()
			highlights:clear_unique_char_hl()
			if opts.show_unique_word_chars == "always" then
				highlights:highlight_unique_chars_on_line(opts)
			end
			return
		end

		--stylua: ignore
		if typed_key == opts.repeat_key or (self.in_motion  and vim.tbl_contains({ opts.f, opts.F, opts.t, opts.T, opts.next, opts.prev }, typed_key)) then
			if opts.show_unique_word_chars ~= "always" then
				highlights:clear_unique_char_hl()
			end
			return
		end

		self.in_motion = false
		highlights:clear_fFtT_hl()
		if opts.show_unique_word_chars ~= "always" then
			highlights:clear_unique_char_hl()
		end
	end, vim.api.nvim_create_namespace("highlightFfTtMotionKeyWatcher"))
end

function fFtT_hl:set_backdrop()
	if not self.opts.backdrop or vim.fn.reg_executing() ~= "" then
		return
	end

	self.highlights:clear_fFtT_hl()
	self.highlights:clear_unique_char_hl()
	self.highlights:redraw()

	local bufnr = vim.api.nvim_get_current_buf()
	local row, col = unpack(vim.api.nvim_win_get_cursor(0))
	row = row - 1
	local line = vim.api.nvim_buf_get_lines(bufnr, row, row + 1, false)[1]
	if not line then
		return
	end

	local from, to, reverse
	reverse = false
	if self.current_motion == self.opts.f or self.current_motion == self.opts.t then
		from, to = col + 1, math.min(vim.fn.strchars(line) - 1, col + 1 + self.opts.line_highlight_radius - 1)
	elseif self.current_motion == self.opts.F or self.current_motion == self.opts.T then
		from, to = math.max(0, col - 1 - self.opts.line_highlight_radius + 1), col - 1
		reverse = true
	end

	if
		self.opts.show_unique_word_chars == "always"
		or self.opts.show_unique_word_chars == "on_key_press" and vim.fn.reg_executing() == ""
	then
		--stylua: ignore start
		if reverse then
			self.highlights:show_unique_word_chars(self.opts, bufnr, row, line, to, from, self.opts.show_all_unique_chars ~= "never", self.opts.show_unique_secondary_chars ~= "never")
		else
			self.highlights:show_unique_word_chars(self.opts, bufnr, row, line, from, to, self.opts.show_all_unique_chars ~= "never", self.opts.show_unique_secondary_chars ~= "never")
		end
		--stylua: ignore end
		self.highlights.redraw()
	end

	self.highlights:set_backdrop_highlight(self.opts, bufnr, line, nil, row, from, to)
	self.highlights.redraw()
end

function fFtT_hl.fFtT_action()
	local opts = fFtT_hl.opts
	local motion = fFtT_hl.current_motion
	local highlights = fFtT_hl.highlights
	local char = fFtT_hl.saved_char
	if not char or not highlights or not opts or not motion then
		return
	end

	if not fFtT_hl.utils:valid_input_char(opts, char, motion) then
		fFtT_hl:motion_escape_sequence()
		vim.schedule(function() --HACK: "fixes" dot repeated deletion of invalid characters
			vim.cmd("undo!")
		end)
		return
	end

	local bufnr = vim.api.nvim_get_current_buf()
	local row, col = unpack(vim.api.nvim_win_get_cursor(0))
	row = row - 1
	local line = vim.api.nvim_buf_get_lines(bufnr, row, row + 1, false)[1]
	if not line then
		return
	end

	local from, to, reverse
	reverse = false
	if motion == opts.f or motion == opts.t then
		from, to = col + 1, math.min(vim.fn.strchars(line) - 1, col + 1 + opts.line_highlight_radius - 1)
	elseif motion == opts.F or motion == opts.T then
		from, to = math.max(0, col - 1 - opts.line_highlight_radius + 1), col - 1
		reverse = true
	end

	if char == opts.reset_key then
		fFtT_hl.in_motion = false
		highlights:clear_fFtT_hl()
		highlights:clear_unique_char_hl()
		if vim.fn.reg_executing() == "" and opts.show_unique_word_chars == "always" then
			highlights:highlight_unique_chars_on_line(opts)
		end
		highlights.redraw()
		return
	end

	if motion == opts.T then
		to = to - 1
	elseif motion == opts.t then
		from = from + 1
	end

	if vim.fn.reg_executing() == "" then
		highlights:clear_fFtT_hl()
		if opts.backdrop then
			highlights:set_backdrop_highlight(opts, bufnr, line, char or nil, row, from, to)
		end
	end

	local match_count = highlights:set_match_highlight(opts, fFtT_hl.utils, bufnr, row, line, from, to, char)
	if match_count <= 1 then
		highlights:clear_fFtT_hl()
	end
	highlights.redraw()
	if match_count <= 0 then
		return opts.repeat_key
	end

	fFtT_hl.last_state = {
		motion = motion or "",
		char = char,
	}
	fFtT_hl.in_motion = true

	---@type integer | nil
	local cursor_pos = col
	local count1 = math.min(3000, vim.v.count1)
	for _ = 1, count1 do
		if not cursor_pos then
			break
		end
		cursor_pos = fFtT_hl:move_cursor_to_char(opts, line, motion or "", char, row, cursor_pos, reverse)
		if not cursor_pos then
			break
		end
		cursor_pos = reverse and cursor_pos - 1 or cursor_pos + 1
	end
end

---@param opts fFTt_highlights.opts
function fFtT_hl:smart_action(opts, motion)
	local bufnr = vim.api.nvim_get_current_buf()
	local row, col = unpack(vim.api.nvim_win_get_cursor(0))
	row = row - 1
	local line = vim.api.nvim_buf_get_lines(bufnr, row, row + 1, false)[1]
	if not line or vim.fn.strchars(line) > opts.line_highlight_radius then
		return
	end

	local last_motion = self.last_state.motion
	local reverse = false
	if last_motion == opts.F or last_motion == opts.T then
		reverse = true
	end

	if motion == opts.F or motion == opts.T then
		reverse = not reverse
	end

	if vim.fn.reg_executing() == "" then
		self.highlights:reapply_last_char_highlight(opts, self.utils, self.last_state, reverse)
	end

	---@type integer | nil
	local cursor_pos = col
	local count1 = math.min(3000, vim.v.count1)
	for _ = 1, count1 do
		if not cursor_pos then
			break
		end
		cursor_pos = self:move_cursor_to_char(opts, line, last_motion, self.last_state.char, row, cursor_pos, reverse)
		if not cursor_pos then
			break
		end
		cursor_pos = reverse and cursor_pos - 1 or cursor_pos + 1
	end

	self.last_state = {
		char = self.last_state.char,
		motion = last_motion,
	}
	self.in_motion = true
end

function fFtT_hl.next_prev_action()
	local opts = fFtT_hl.opts or {}
	local motion = fFtT_hl.current_motion or ""
	if not fFtT_hl.last_state or fFtT_hl.utils:disabled_file_or_buftype(opts) then
		return
	end
	local bufnr = vim.api.nvim_get_current_buf()
	local row, col = unpack(vim.api.nvim_win_get_cursor(0))
	row = row - 1
	local line = vim.api.nvim_buf_get_lines(bufnr, row, row + 1, false)[1]
	if not line then
		return
	end

	local last_motion = fFtT_hl.last_state.motion
	local reverse = (last_motion == opts.F or last_motion == opts.T)
	if motion == opts.prev then
		reverse = not reverse
	end

	fFtT_hl.highlights:reapply_last_char_highlight(opts, fFtT_hl.utils, fFtT_hl.last_state, reverse)

	---@type integer | nil
	local cursor_pos = col
	local count1 = math.min(3000, vim.v.count1)
	for _ = 1, count1 do
		if not cursor_pos then
			break
		end
		cursor_pos =
			fFtT_hl:move_cursor_to_char(opts, line, last_motion, fFtT_hl.last_state.char, row, cursor_pos, reverse)
		if not cursor_pos then
			break
		end
		cursor_pos = reverse and cursor_pos - 1 or cursor_pos + 1
	end

	fFtT_hl.in_motion = true
end

return fFtT_hl
