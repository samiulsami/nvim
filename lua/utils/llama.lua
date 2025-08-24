-- llama.lua: Lua transpilation of autoload/llama.vim
-- Maintains 1-1 functionality with the original Vimscript implementation

local M = {}

-- Set up highlight groups (equivalent to the highlight commands from the original)
vim.api.nvim_set_hl(0, "llama_hl_hint", { default = true, ctermfg = 202, fg = "#ff772f" })
vim.api.nvim_set_hl(0, "llama_hl_info", { default = true, ctermfg = 119, fg = "#77ff2f" })

-- Setup math.random seed
math.randomseed(os.time())

-- Module state variables (originally script-local s: variables)
local default_config = {
	endpoint = "http://127.0.0.1:8012/infill",
	api_key = "",
	n_prefix = 256,
	n_suffix = 64,
	n_predict = 128,
	stop_strings = {},
	t_max_prompt_ms = 500,
	t_max_predict_ms = 1000,
	show_info = 2,
	auto_fim = true,
	max_line_suffix = 8,
	max_cache_keys = 250,
	ring_n_chunks = 16,
	ring_chunk_size = 64,
	ring_scope = 1024,
	ring_update_ms = 1000,
	keymap_trigger = "<C-F>",
	keymap_accept_full = "<Tab>",
	keymap_accept_line = "<S-Tab>",
	keymap_accept_word = "<C-B>",
	-- Enhanced context options
	include_recent_buffers = true,
	max_recent_buffers = 3,
	max_buffer_lines = 50,
}

local llama_enabled = false
local fim_data = {}
local ring_chunks = {} -- current set of chunks used as extra context
local ring_queued = {} -- chunks that are queued to be sent for processing
local ring_n_evict = 0
local hint_shown = false
local pos_y_pick = -9999 -- last y where we picked a chunk
local indent_last = -1 -- last indentation level that was accepted
local timer_fim = -1
local t_last_move = vim.loop.hrtime() -- last time the cursor moved
local current_job = nil
local ghost_text_nvim = false
local ghost_text_vim = false
local hlgroup_hint = ""
local hlgroup_info = ""
local n_cached = 0
local truncated = false

-- Initialize global configuration
local function init_config()
	local user_config = vim.g.llama_config or {}
	vim.g.llama_config = vim.tbl_deep_extend("force", vim.deepcopy(default_config), user_config)
end

-- Initialize on module load
init_config()

-- Utility functions

-- get the number of leading spaces of a string
local function get_indent(str)
	local count = 0
	for i = 1, #str do
		local char = str:sub(i, i)
		if char == "\t" then
			count = count + vim.bo.tabstop
		elseif char == " " then
			count = count + 1
		else
			break
		end
	end
	return count
end

-- Random number generator (equivalent to s:rand)
local function rand(i0, i1)
	return i0 + math.random(0, i1 - i0)
end

-- Helper function to get cache size
local function cache_size()
	if vim.g.cache_data == nil then
		return 0
	end
	return vim.tbl_count(vim.g.cache_data)
end

-- Helper function to get cache value and update LRU order
local function cache_get(key)
	if vim.g.cache_data[key] == nil then
		return nil
	end

	-- Update LRU order - remove key if it exists and add to end (most recent)
	local new_order = {}
	for _, k in ipairs(vim.g.cache_lru_order) do
		if k ~= key then
			table.insert(new_order, k)
		end
	end
	table.insert(new_order, key)
	vim.g.cache_lru_order = new_order

	return vim.g.cache_data[key]
end

-- Cache insert with LRU eviction
local function cache_insert(key, value)
	-- Initialize cache globals if they don't exist
	if vim.g.cache_data == nil then
		vim.g.cache_data = {}
	end
	if vim.g.cache_lru_order == nil then
		vim.g.cache_lru_order = {}
	end

	-- Check if we need to evict an entry
	if cache_size() > (vim.g.llama_config.max_cache_keys - 1) then
		-- Get the least recently used key (first in order list)
		local lru_key = vim.g.cache_lru_order[1]
		-- Remove from cache data
		vim.g.cache_data[lru_key] = nil
		-- Remove from LRU order
		table.remove(vim.g.cache_lru_order, 1)
	end

	-- Update the cache
	vim.g.cache_data[key] = value

	-- Update LRU order - remove key if it exists and add to end (most recent)
	local new_order = {}
	for _, k in ipairs(vim.g.cache_lru_order) do
		if k ~= key then
			table.insert(new_order, k)
		end
	end
	table.insert(new_order, key)
	vim.g.cache_lru_order = new_order
end

-- Public API functions

function M.disable()
	M.fim_hide()
	vim.api.nvim_clear_autocmds({ group = "llama" })
	vim.cmd("silent! iunmap " .. vim.g.llama_config.keymap_trigger)
	llama_enabled = false
end

function M.toggle()
	if llama_enabled then
		M.disable()
	else
		M.init()
	end
end

function M.debug_context()
	print("=== Llama.vim Enhanced Context Debug ===")

	local contexts = {}

	-- Recent buffers
	if vim.g.llama_config.include_recent_buffers then
		local recent_buffers = M.get_recent_buffers()
		for _, buffer_ctx in ipairs(recent_buffers) do
			table.insert(contexts, { type = "Recent buffer", size = #buffer_ctx.text, filename = buffer_ctx.filename })
		end
	end

	-- Ring chunks
	for _, chunk_data in ipairs(ring_chunks) do
		table.insert(contexts, { type = "Ring chunk", size = #chunk_data.str, filename = chunk_data.filename })
	end

	if #contexts == 0 then
		print("No enhanced context sources available")
		return
	end

	print("Enhanced context sources (" .. #contexts .. " total):")
	for i, ctx in ipairs(contexts) do
		print(string.format("  %d. %s: %s (%d chars)", i, ctx.type, ctx.filename, ctx.size))
	end

	local total_size = 0
	for _, ctx in ipairs(contexts) do
		total_size = total_size + ctx.size
	end
	print("Total context size: " .. total_size .. " characters")
end

function M.setup_commands()
	vim.api.nvim_create_user_command("LlamaEnable", function()
		M.init()
	end, {})

	vim.api.nvim_create_user_command("LlamaDisable", function()
		M.disable()
	end, {})

	vim.api.nvim_create_user_command("LlamaToggle", function()
		M.toggle()
	end, {})

	vim.api.nvim_create_user_command("LlamaDebugContext", function()
		M.debug_context()
	end, { desc = "Show what context would be sent to LLM" })
end

-- Forward declarations for functions used in init
local fim_inline, on_move, pick_chunk, ring_update

function M.init()
	if vim.fn.executable("curl") == 0 then
		vim.api.nvim_echo({ { 'llama.vim requires the "curl" command to be available', "WarningMsg" } }, false, {})
		return
	end

	M.setup_commands()

	fim_data = {}

	-- Initialize cache
	if vim.g.cache_data == nil then
		vim.g.cache_data = {}
	end
	if vim.g.cache_lru_order == nil then
		vim.g.cache_lru_order = {}
	end

	ring_chunks = {} -- current set of chunks used as extra context
	ring_queued = {} -- chunks that are queued to be sent for processing
	ring_n_evict = 0

	hint_shown = false
	pos_y_pick = -9999 -- last y where we picked a chunk
	indent_last = -1 -- last indentation level that was accepted

	timer_fim = -1
	t_last_move = vim.loop.hrtime() -- last time the cursor moved

	current_job = nil

	-- In Neovim, we always use nvim APIs
	ghost_text_nvim = true
	ghost_text_vim = false

	if ghost_text_vim then
		if vim.version().major < 9 or (vim.version().major == 9 and vim.version().minor < 1) then
			print("Warning: llama.vim requires version 9.1 or greater. Current version: " .. vim.v.version)
		end
		hlgroup_hint = "llama_hl_hint"
		hlgroup_info = "llama_hl_info"

		if vim.fn.empty(vim.fn.prop_type_get(hlgroup_hint)) == 1 then
			vim.fn.prop_type_add(hlgroup_hint, { highlight = hlgroup_hint })
		end
		if vim.fn.empty(vim.fn.prop_type_get(hlgroup_info)) == 1 then
			vim.fn.prop_type_add(hlgroup_info, { highlight = hlgroup_info })
		end
	end

	-- Create autocommand group
	local augroup_id = vim.api.nvim_create_augroup("llama", { clear = true })

	-- Set up autocommands
	vim.api.nvim_create_autocmd("InsertEnter", {
		group = augroup_id,
		callback = function()
			vim.keymap.set("i", vim.g.llama_config.keymap_trigger, function()
				return fim_inline(false, false)
			end, { expr = true, silent = true, buffer = true })
		end,
	})

	vim.api.nvim_create_autocmd("InsertLeavePre", {
		group = augroup_id,
		callback = function()
			M.fim_hide()
		end,
	})

	vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
		group = augroup_id,
		callback = on_move,
	})

	vim.api.nvim_create_autocmd({ "CompleteChanged" }, {
		group = augroup_id,
		callback = function()
			M.fim_hide()
		end,
	})

	vim.api.nvim_create_autocmd("CompleteDone", {
		group = augroup_id,
		callback = on_move,
	})

	if vim.g.llama_config.auto_fim then
		vim.api.nvim_create_autocmd("CursorMovedI", {
			group = augroup_id,
			callback = function()
				M.fim(-1, -1, true, {}, true)
			end,
		})
	end

	-- gather chunks upon yanking
	vim.api.nvim_create_autocmd("TextYankPost", {
		group = augroup_id,
		callback = function()
			if vim.v.event.operator == "y" then
				pick_chunk(vim.v.event.regcontents, false, true)
			end
		end,
	})

	-- gather chunks upon entering/leaving a buffer
	vim.api.nvim_create_autocmd("BufEnter", {
		group = augroup_id,
		callback = function()
			vim.defer_fn(function()
				local line_num = vim.api.nvim_win_get_cursor(0)[1]
				local start_line = math.max(1, line_num - math.floor(vim.g.llama_config.ring_chunk_size / 2))
				local end_line = math.min(
					line_num + math.floor(vim.g.llama_config.ring_chunk_size / 2),
					vim.api.nvim_buf_line_count(0)
				)
				local lines = vim.api.nvim_buf_get_lines(0, start_line - 1, end_line, true)
				pick_chunk(lines, true, true)
			end, 100)
		end,
	})

	vim.api.nvim_create_autocmd("BufLeave", {
		group = augroup_id,
		callback = function()
			local line_num = vim.api.nvim_win_get_cursor(0)[1]
			local start_line = math.max(1, line_num - math.floor(vim.g.llama_config.ring_chunk_size / 2))
			local end_line =
				math.min(line_num + math.floor(vim.g.llama_config.ring_chunk_size / 2), vim.api.nvim_buf_line_count(0))
			local lines = vim.api.nvim_buf_get_lines(0, start_line - 1, end_line, true)
			pick_chunk(lines, true, true)
		end,
	})

	-- gather chunk upon saving the file
	vim.api.nvim_create_autocmd("BufWritePost", {
		group = augroup_id,
		callback = function()
			local line_num = vim.api.nvim_win_get_cursor(0)[1]
			local start_line = math.max(1, line_num - math.floor(vim.g.llama_config.ring_chunk_size / 2))
			local end_line =
				math.min(line_num + math.floor(vim.g.llama_config.ring_chunk_size / 2), vim.api.nvim_buf_line_count(0))
			local lines = vim.api.nvim_buf_get_lines(0, start_line - 1, end_line, true)
			pick_chunk(lines, true, true)
		end,
	})

	pcall(M.fim_hide)

	-- init background update of the ring buffer
	if vim.g.llama_config.ring_n_chunks > 0 then
		ring_update()
	end

	llama_enabled = true
end

-- Ring buffer system functions

-- compute how similar two chunks of text are
-- 0 - no similarity, 1 - high similarity
local function chunk_sim(c0, c1)
	local lines0 = #c0
	local lines1 = #c1

	local common = 0

	for _, line0 in ipairs(c0) do
		for _, line1 in ipairs(c1) do
			if line0 == line1 then
				common = common + 1
				break
			end
		end
	end

	return 2.0 * common / (lines0 + lines1)
end

-- pick a random chunk of size ring_chunk_size from the provided text and queue it for processing
-- no_mod   - do not pick chunks from buffers with pending changes
-- do_evict - evict chunks that are very similar to the new one
pick_chunk = function(text, no_mod, do_evict)
	-- do not pick chunks from buffers with pending changes or buffers that are not files
	local bufnr = vim.api.nvim_get_current_buf()
	if
		no_mod
		and (
			vim.bo[bufnr].modified
			or not vim.api.nvim_buf_is_loaded(bufnr)
			or not vim.fn.filereadable(vim.fn.expand("%"))
		)
	then
		return
	end

	-- if the extra context option is disabled - do nothing
	if vim.g.llama_config.ring_n_chunks <= 0 then
		return
	end

	-- don't pick very small chunks
	if #text < 3 then
		return
	end

	local chunk
	if #text + 1 < vim.g.llama_config.ring_chunk_size then
		chunk = text
	else
		local l0 = rand(0, math.max(0, #text - math.floor(vim.g.llama_config.ring_chunk_size / 2)))
		local l1 = math.min(l0 + math.floor(vim.g.llama_config.ring_chunk_size / 2), #text)

		chunk = {}
		for i = l0 + 1, l1 do -- Lua 1-based indexing
			table.insert(chunk, text[i])
		end
	end

	local chunk_str = table.concat(chunk, "\n") .. "\n"

	-- check if this chunk is already added
	local exist = false

	for i = 1, #ring_chunks do
		if vim.deep_equal(ring_chunks[i].data, chunk) then
			exist = true
			break
		end
	end

	for i = 1, #ring_queued do
		if vim.deep_equal(ring_queued[i].data, chunk) then
			exist = true
			break
		end
	end

	if exist then
		return
	end

	-- evict queued chunks that are very similar to the new one
	for i = #ring_queued, 1, -1 do
		if chunk_sim(ring_queued[i].data, chunk) > 0.9 then
			if do_evict then
				table.remove(ring_queued, i)
				ring_n_evict = ring_n_evict + 1
			else
				return
			end
		end
	end

	-- also from ring_chunks
	for i = #ring_chunks, 1, -1 do
		if chunk_sim(ring_chunks[i].data, chunk) > 0.9 then
			if do_evict then
				table.remove(ring_chunks, i)
				ring_n_evict = ring_n_evict + 1
			else
				return
			end
		end
	end

	-- TODO: become parameter ?
	if #ring_queued == 16 then
		table.remove(ring_queued, 1)
	end

	table.insert(ring_queued, {
		data = chunk,
		str = chunk_str,
		time = vim.loop.hrtime(),
		filename = vim.fn.expand("%"),
	})
end

-- picks a queued chunk, sends it for processing and adds it to ring_chunks
-- called every ring_update_ms
ring_update = function()
	vim.defer_fn(ring_update, vim.g.llama_config.ring_update_ms)

	-- update only if in normal mode or if the cursor hasn't moved for a while
	local current_mode = vim.fn.mode()
	if current_mode ~= "n" and (vim.loop.hrtime() - t_last_move) / 1e9 < 3.0 then
		return
	end

	if #ring_queued == 0 then
		return
	end

	-- move the first queued chunk to the ring buffer
	if #ring_chunks == vim.g.llama_config.ring_n_chunks then
		table.remove(ring_chunks, 1)
	end

	table.insert(ring_chunks, table.remove(ring_queued, 1))

	-- send asynchronous job with the new extra context so that it is ready for the next FIM
	local extra_context = {}
	for _, chunk in ipairs(ring_chunks) do
		table.insert(extra_context, {
			text = chunk.str,
			time = chunk.time,
			filename = chunk.filename,
		})
	end

	-- no samplers needed here
	local request = vim.json.encode({
		input_prefix = "",
		input_suffix = "",
		input_extra = extra_context,
		prompt = "",
		n_predict = 0,
		temperature = 0.0,
		stream = false,
		samplers = {},
		cache_prompt = true,
		t_max_prompt_ms = 1,
		t_max_predict_ms = 1,
		response_fields = { "" },
	})

	local curl_command = {
		"curl",
		"--silent",
		"--no-buffer",
		"--request",
		"POST",
		"--url",
		vim.g.llama_config.endpoint,
		"--header",
		"Content-Type: application/json",
		"--data",
		"@-",
	}

	if vim.g.llama_config.api_key ~= nil and #vim.g.llama_config.api_key > 0 then
		table.insert(curl_command, "--header")
		table.insert(curl_command, "Authorization: Bearer " .. vim.g.llama_config.api_key)
	end

	-- no callbacks because we don't need to process the response
	if ghost_text_nvim then
		local jobid = vim.fn.jobstart(curl_command, { stdin = "pipe" })
		vim.fn.chansend(jobid, request)
		vim.fn.chanclose(jobid, "stdin")
	elseif ghost_text_vim then
		local jobid = vim.fn.jobstart(curl_command, { stdin = "pipe" })
		local channel = vim.fn.job_getchannel(jobid)
		vim.fn.ch_sendraw(channel, request)
		vim.fn.ch_close_in(channel)
	end
end

-- FIM core logic functions

-- get the local context at a specified position
-- prev can optionally contain a previous completion for this position
--   in such cases, create the local context as if the completion was already inserted
local function fim_ctx_local(pos_x, pos_y, prev)
	local max_y = vim.api.nvim_buf_line_count(0)

	local line_cur, line_cur_prefix, line_cur_suffix, lines_prefix, lines_suffix, indent

	if #prev == 0 then
		line_cur = vim.api.nvim_buf_get_lines(0, pos_y - 1, pos_y, true)[1] or ""

		line_cur_prefix = string.sub(line_cur, 1, pos_x)
		line_cur_suffix = string.sub(line_cur, pos_x + 1)

		lines_prefix =
			vim.api.nvim_buf_get_lines(0, math.max(0, pos_y - vim.g.llama_config.n_prefix - 1), pos_y - 1, true)
		lines_suffix = vim.api.nvim_buf_get_lines(0, pos_y, math.min(max_y, pos_y + vim.g.llama_config.n_suffix), true)

		-- special handling of lines full of whitespaces - start from the beginning of the line
		if vim.fn.match(line_cur, "^\\s*$") >= 0 then
			indent = 0
			line_cur_prefix = ""
			line_cur_suffix = ""
		else
			-- the indentation of the current line
			indent = #vim.fn.matchstr(line_cur, "^\\s*")
		end
	else
		if #prev == 1 then
			line_cur = (vim.api.nvim_buf_get_lines(0, pos_y - 1, pos_y, true)[1] or "") .. prev[1]
		else
			line_cur = prev[#prev]
		end

		line_cur_prefix = line_cur
		line_cur_suffix = ""

		lines_prefix =
			vim.api.nvim_buf_get_lines(0, math.max(0, pos_y - vim.g.llama_config.n_prefix + #prev - 2), pos_y - 1, true)
		if #prev > 1 then
			table.insert(lines_prefix, (vim.api.nvim_buf_get_lines(0, pos_y - 1, pos_y, true)[1] or "") .. prev[1])

			for i = 2, #prev - 1 do
				table.insert(lines_prefix, prev[i])
			end
		end

		lines_suffix = vim.api.nvim_buf_get_lines(0, pos_y, math.min(max_y, pos_y + vim.g.llama_config.n_suffix), true)

		indent = indent_last
	end

	local prefix = table.concat(lines_prefix, "\n") .. "\n"
	local middle = line_cur_prefix
	local suffix = line_cur_suffix .. "\n" .. table.concat(lines_suffix, "\n") .. "\n"

	return {
		prefix = prefix,
		middle = middle,
		suffix = suffix,
		indent = indent,
		line_cur = line_cur,
		line_cur_prefix = line_cur_prefix,
		line_cur_suffix = line_cur_suffix,
	}
end

-- necessary for 'inoremap <expr>'
fim_inline = function(is_auto, use_cache)
	-- we already have a suggestion displayed - hide it
	if hint_shown and not is_auto then
		M.fim_hide()
		return ""
	end

	M.fim(-1, -1, is_auto, {}, use_cache)

	return ""
end

-- Forward declarations for functions used in fim
local fim_on_response, fim_on_exit

-- the main FIM call
-- takes local context around the cursor and sends it together with the extra context to the server for completion
function M.fim(pos_x, pos_y, is_auto, prev, use_cache)
	pos_x = pos_x or -1
	pos_y = pos_y or -1

	if pos_x < 0 then
		pos_x = vim.api.nvim_win_get_cursor(0)[2]
	end

	if pos_y < 0 then
		pos_y = vim.api.nvim_win_get_cursor(0)[1]
	end

	-- avoid sending repeated requests too fast
	if current_job ~= nil then
		if timer_fim ~= -1 then
			-- TODO: Lua doesn't have timer_stop equivalent, would need to track timer handles
			-- For now, just reset timer_fim
			timer_fim = -1
		end

		timer_fim = 1 -- placeholder, vim.defer_fn doesn't return timer id
		vim.defer_fn(function()
			M.fim(pos_x, pos_y, true, prev, use_cache)
		end, 100)
		return
	end

	local ctx_local = fim_ctx_local(pos_x, pos_y, prev)

	local prefix = ctx_local.prefix
	local middle = ctx_local.middle
	local suffix = ctx_local.suffix
	local indent = ctx_local.indent

	if is_auto and #ctx_local.line_cur_suffix > vim.g.llama_config.max_line_suffix then
		return
	end

	local t_max_predict_ms = vim.g.llama_config.t_max_predict_ms
	if #prev == 0 then
		-- the first request is quick - we will launch a speculative request after this one is displayed
		t_max_predict_ms = 250
	end

	-- compute multiple hashes that can be used to generate a completion for which the
	--   first few lines are missing. this happens when we have scrolled down a bit from where the original
	--   generation was done
	local hashes = {}

	table.insert(hashes, vim.fn.sha256(prefix .. middle .. "Î" .. suffix))

	local prefix_trim = prefix
	for _ = 1, 3 do
		prefix_trim = vim.fn.substitute(prefix_trim, "^[^\\n]*\\n", "", "")
		if #prefix_trim == 0 then
			break
		end

		table.insert(hashes, vim.fn.sha256(prefix_trim .. middle .. "Î" .. suffix))
	end

	-- if we already have a cached completion for one of the hashes, don't send a request
	if use_cache then
		for _, hash in ipairs(hashes) do
			local cache_val = cache_get(hash)
			if cache_val ~= nil then
				return
			end
		end
	end

	-- TODO: this might be incorrect
	indent_last = indent

	-- TODO: refactor in a function
	local current_line = vim.api.nvim_win_get_cursor(0)[1]
	local start_line = math.max(1, current_line - math.floor(vim.g.llama_config.ring_chunk_size / 2))
	local end_line =
		math.min(current_line + math.floor(vim.g.llama_config.ring_chunk_size / 2), vim.api.nvim_buf_line_count(0))
	local text = vim.api.nvim_buf_get_lines(0, start_line - 1, end_line, true)

	local l0 = rand(0, math.max(0, #text - math.floor(vim.g.llama_config.ring_chunk_size / 2)))
	local l1 = math.min(l0 + math.floor(vim.g.llama_config.ring_chunk_size / 2), #text)

	local chunk = {}
	for i = l0 + 1, l1 do
		table.insert(chunk, text[i])
	end

	-- prepare the extra context data
	local extra_ctx = {}

	-- Add existing ring chunks
	for _, chunk_data in ipairs(ring_chunks) do
		table.insert(extra_ctx, {
			text = chunk_data.str,
			time = chunk_data.time,
			filename = chunk_data.filename,
		})
	end

	-- Add enhanced context sources
	if vim.g.llama_config.include_recent_buffers then
		local recent_buffers = M.get_recent_buffers()
		for _, buffer_ctx in ipairs(recent_buffers) do
			table.insert(extra_ctx, buffer_ctx)
		end
	end

	local request = vim.json.encode({
		input_prefix = prefix,
		input_suffix = suffix,
		input_extra = extra_ctx,
		prompt = middle,
		n_predict = vim.g.llama_config.n_predict,
		stop = vim.g.llama_config.stop_strings,
		n_indent = indent,
		top_k = 40,
		top_p = 0.90,
		stream = false,
		samplers = { "top_k", "top_p", "infill" },
		cache_prompt = true,
		t_max_prompt_ms = vim.g.llama_config.t_max_prompt_ms,
		t_max_predict_ms = t_max_predict_ms,
		response_fields = {
			"content",
			"timings/prompt_n",
			"timings/prompt_ms",
			"timings/prompt_per_token_ms",
			"timings/prompt_per_second",
			"timings/predicted_n",
			"timings/predicted_ms",
			"timings/predicted_per_token_ms",
			"timings/predicted_per_second",
			"truncated",
			"tokens_cached",
		},
	})

	local curl_command = {
		"curl",
		"--silent",
		"--no-buffer",
		"--request",
		"POST",
		"--url",
		vim.g.llama_config.endpoint,
		"--header",
		"Content-Type: application/json",
		"--data",
		"@-",
	}

	if vim.g.llama_config.api_key ~= nil and #vim.g.llama_config.api_key > 0 then
		table.insert(curl_command, "--header")
		table.insert(curl_command, "Authorization: Bearer " .. vim.g.llama_config.api_key)
	end

	if current_job ~= nil then
		if ghost_text_nvim then
			vim.fn.jobstop(current_job)
		elseif ghost_text_vim then
			vim.fn.job_stop(current_job)
		end
	end

	-- send the request asynchronously
	if ghost_text_nvim then
		current_job = vim.fn.jobstart(curl_command, {
			on_stdout = function(job_id, data, event)
				fim_on_response(hashes, job_id, data, event)
			end,
			on_exit = fim_on_exit,
			stdout_buffered = true,
			stdin = "pipe",
		})
		vim.fn.chansend(current_job, request)
		vim.fn.chanclose(current_job, "stdin")
	elseif ghost_text_vim then
		current_job = vim.fn.jobstart(curl_command, {
			on_stdout = function(job_id, data)
				fim_on_response(hashes, job_id, data)
			end,
			on_exit = fim_on_exit,
			stdin = "pipe",
		})

		local channel = vim.fn.job_getchannel(current_job)
		vim.fn.ch_sendraw(channel, request)
		vim.fn.ch_close_in(channel)
	end

	-- TODO: per-file location
	local delta_y = math.abs(pos_y - pos_y_pick)

	-- gather some extra context nearby and process it in the background
	-- only gather chunks if the cursor has moved a lot
	if is_auto and delta_y > 32 then
		local max_y = vim.api.nvim_buf_line_count(0)

		-- expand the prefix even further
		local prefix_start = math.max(1, pos_y - vim.g.llama_config.ring_scope)
		local prefix_end = math.max(1, pos_y - vim.g.llama_config.n_prefix)
		if prefix_start < prefix_end then
			local prefix_lines = vim.api.nvim_buf_get_lines(0, prefix_start - 1, prefix_end, true)
			pick_chunk(prefix_lines, false, false)
		end

		-- pick a suffix chunk
		local suffix_start = math.min(max_y, pos_y + vim.g.llama_config.n_suffix)
		local suffix_end = math.min(max_y, pos_y + vim.g.llama_config.n_suffix + vim.g.llama_config.ring_chunk_size)
		if suffix_start < suffix_end then
			local suffix_lines = vim.api.nvim_buf_get_lines(0, suffix_start - 1, suffix_end, true)
			pick_chunk(suffix_lines, false, false)
		end

		pos_y_pick = pos_y
	end
end

-- Response handling functions

-- Forward declarations for functions used in response handling
local fim_render, fim_try_hint

-- callback that processes the FIM result from the server
fim_on_response = function(hashes, _, data, _)
	local raw
	if ghost_text_nvim then
		raw = table.concat(data, "\n")
	elseif ghost_text_vim then
		raw = data
	end

	-- ignore empty results
	if #raw == 0 then
		return
	end

	-- ensure the response is valid JSON, starting with a fast check before full decode
	if not (string.match(raw, "^%s*{") and string.match(raw, '"content"%s*:')) then
		return
	end

	local ok, response = pcall(vim.json.decode, raw)
	if not ok then
		return
	end

	-- put the response in the cache
	for _, hash in ipairs(hashes) do
		cache_insert(hash, raw)
	end

	-- if nothing is currently displayed - show the hint directly
	if not hint_shown or not fim_data.can_accept then
		local pos_x = vim.api.nvim_win_get_cursor(0)[2]
		local pos_y = vim.api.nvim_win_get_cursor(0)[1]

		-- Check if we're still in insert mode before showing hint
		local current_mode = vim.fn.mode()
		if string.match(current_mode, "^[iic]") and response.content and #response.content > 0 then
			fim_render(pos_x, pos_y, raw)
		end
	end
end

fim_on_exit = function(_, exit_code, _)
	if exit_code ~= 0 then
		vim.notify("HTTP request failed with exit code: " .. exit_code, vim.log.levels.ERROR)
	end
	current_job = nil
end

on_move = function()
	t_last_move = vim.loop.hrtime()

	M.fim_hide()

	local pos_x = vim.api.nvim_win_get_cursor(0)[2]
	local pos_y = vim.api.nvim_win_get_cursor(0)[1]

	fim_try_hint(pos_x, pos_y)
end

-- try to generate a suggestion using the data in the cache
fim_try_hint = function(pos_x, pos_y)
	-- show the suggestion only in insert mode
	local current_mode = vim.fn.mode()
	if not string.match(current_mode, "^[iic]") then
		return
	end

	local ctx_local = fim_ctx_local(pos_x, pos_y, {})

	local prefix = ctx_local.prefix
	local middle = ctx_local.middle
	local suffix = ctx_local.suffix

	local hash = vim.fn.sha256(prefix .. middle .. "Î" .. suffix)

	-- Check if the completion is cached (and update LRU order)
	local raw = cache_get(hash)

	-- ... or if there is a cached completion nearby (10 characters behind)
	-- Looks at the previous 10 characters to see if a completion is cached. If one is found at (x,y)
	-- then it checks that the characters typed after (x,y) match up with the cached completion result.
	if raw then
		local pm = prefix .. middle
		local best = 0

		for i = 0, 127 do
			local removed = string.sub(pm, -(1 + i))
			local ctx_new = string.sub(pm, 1, -(2 + i)) .. "Î" .. suffix

			local hash_new = vim.fn.sha256(ctx_new)
			local response_cached = cache_get(hash_new)
			if response_cached and response_cached ~= "" then
				local ok, response = pcall(vim.json.decode, response_cached)
				if not ok then
					goto continue
				end

				if string.sub(response.content, 1, i + 1) ~= removed then
					goto continue
				end

				response.content = string.sub(response.content, i + 2)
				if #response.content > 0 then
					if raw then
						raw = vim.json.encode(response)
					elseif #response.content > best then
						best = #response.content
						raw = vim.json.encode(response)
					end
				end
			end
			::continue::
		end

		fim_render(pos_x, pos_y, raw)
		-- run async speculative FIM in the background for this position
		if hint_shown then
			M.fim(pos_x, pos_y, true, fim_data.content, true)
		end
	end
end

-- UI and interaction functions

-- render a suggestion at the current cursor location
fim_render = function(pos_x, pos_y, data)
	-- do not show if there is a completion in progress
	if vim.fn.pumvisible() == 1 then
		return
	end

	local raw = data

	local can_accept = true
	local has_info = false

	local n_prompt = 0
	local t_prompt_ms = 1.0
	local s_prompt = 0

	local n_predict = 0
	local t_predict_ms = 1.0
	local s_predict = 0

	local content = {}

	-- get the generated suggestion
	if can_accept then
		local ok, response = pcall(vim.json.decode, raw)
		if not ok then
			return
		end

		local content_str = response.content or ""
		for part in vim.gsplit(content_str, "\n", { plain = true }) do
			table.insert(content, part)
		end

		-- remove trailing new lines
		while #content > 0 and content[#content] == "" do
			table.remove(content)
		end

		n_cached = response.tokens_cached or 0
		truncated = response.truncated or false

		-- if response.timings is available
		if
			response.timings
			and response.timings.prompt_n
			and response.timings.prompt_ms
			and response.timings.prompt_per_second
			and response.timings.predicted_n
			and response.timings.predicted_ms
			and response.timings.predicted_per_second
		then
			n_prompt = response.timings.prompt_n or 0
			t_prompt_ms = response.timings.prompt_ms or 1
			s_prompt = response.timings.prompt_per_second or 0

			n_predict = response.timings.predicted_n or 0
			t_predict_ms = response.timings.predicted_ms or 1
			s_predict = response.timings.predicted_per_second or 0
		end

		has_info = true
	end

	if #content == 0 then
		table.insert(content, "")
		can_accept = false
	end

	local line_cur = vim.api.nvim_buf_get_lines(0, pos_y - 1, pos_y, true)[1] or ""

	-- if the current line is full of whitespaces, trim as much whitespaces from the suggestion
	if vim.fn.match(line_cur, "^\\s*$") >= 0 then
		local lead = math.min(#vim.fn.matchstr(content[1], "^\\s*"), #line_cur)

		line_cur = string.sub(content[1], 1, lead)
		content[1] = string.sub(content[1], lead + 1)
	end

	local line_cur_prefix = string.sub(line_cur, 1, pos_x)
	local line_cur_suffix = string.sub(line_cur, pos_x + 1)

	-- NOTE: the following is logic for discarding predictions that repeat existing text
	--       the code is quite ugly and there is very likely a simpler and more canonical way to implement this
	--
	--       still, I wonder if there is some better way that avoids having to do these special hacks?
	--       on one hand, the LLM 'sees' the contents of the file before we start editing, so it is normal that it would
	--       start generating whatever we have given it via the extra context. but on the other hand, it's not very
	--       helpful to re-generate the same code that is already there

	-- truncate the suggestion if the first line is empty
	if #content == 1 and content[1] == "" then
		content = { "" }
	end

	-- ... and the next lines are repeated
	if #content > 1 and content[1] == "" then
		local next_lines = vim.api.nvim_buf_get_lines(0, pos_y, pos_y + #content - 1, true)
		local content_tail = {}
		for i = 2, #content do
			table.insert(content_tail, content[i])
		end
		if vim.deep_equal(content_tail, next_lines) then
			content = { "" }
		end
	end

	-- truncate the suggestion if it repeats the suffix
	if #content == 1 and content[1] == line_cur_suffix then
		content = { "" }
	end

	-- find the first non-empty line (strip whitespace)
	local cmp_y = pos_y + 1
	while cmp_y <= vim.api.nvim_buf_line_count(0) do
		local line = vim.api.nvim_buf_get_lines(0, cmp_y - 1, cmp_y, true)[1] or ""
		if not string.match(line, "^%s*$") then
			break
		end
		cmp_y = cmp_y + 1
	end

	local cmp_line = ""
	if cmp_y <= vim.api.nvim_buf_line_count(0) then
		cmp_line = vim.api.nvim_buf_get_lines(0, cmp_y - 1, cmp_y, true)[1] or ""
	end

	if (line_cur_prefix .. content[1]) == cmp_line then
		-- truncate the suggestion if it repeats the next line
		if #content == 1 then
			content = { "" }
		end

		-- ... or if the second line of the suggestion is the prefix of line cmp_y + 1
		if #content == 2 then
			local next_line = ""
			if cmp_y + 1 <= vim.api.nvim_buf_line_count(0) then
				next_line = vim.api.nvim_buf_get_lines(0, cmp_y, cmp_y + 1, true)[1] or ""
			end
			if content[2] == string.sub(next_line, 1, #content[2]) then
				content = { "" }
			end
		end

		-- ... or if the middle chunk of lines of the suggestion is the same as [cmp_y + 1, cmp_y + #content - 1)
		if #content > 2 then
			local suggestion_middle = {}
			for i = 2, #content - 1 do
				table.insert(suggestion_middle, content[i])
			end
			local file_middle = vim.api.nvim_buf_get_lines(0, cmp_y, cmp_y + #content - 2, true)
			if vim.deep_equal(suggestion_middle, file_middle) then
				content = { "" }
			end
		end
	end

	content[#content] = content[#content] .. line_cur_suffix

	-- if only whitespaces - do not accept
	if string.match(table.concat(content, "\n"), "^%s*$") then
		can_accept = false
	end

	-- display virtual text with the suggestion
	local bufnr = vim.api.nvim_get_current_buf()

	local id_vt_fim
	if ghost_text_nvim then
		id_vt_fim = vim.api.nvim_create_namespace("vt_fim")
	end

	local info = ""

	-- construct the info message
	if vim.g.llama_config.show_info > 0 and has_info then
		local prefix_info = "   "

		if truncated then
			info = string.format(
				"%s | WARNING: the context is full: %d, increase the server context size or reduce g:llama_config.ring_n_chunks",
				vim.g.llama_config.show_info == 2 and prefix_info or "llama.vim",
				n_cached
			)
		else
			info = string.format(
				"%s | c: %d, r: %d/%d, e: %d, q: %d/16, C: %d/%d | p: %d (%.2f ms, %.2f t/s) | g: %d (%.2f ms, %.2f t/s)",
				vim.g.llama_config.show_info == 2 and prefix_info or "llama.vim",
				n_cached,
				#ring_chunks,
				vim.g.llama_config.ring_n_chunks,
				ring_n_evict,
				#ring_queued,
				cache_size(),
				vim.g.llama_config.max_cache_keys,
				n_prompt,
				t_prompt_ms,
				s_prompt,
				n_predict,
				t_predict_ms,
				s_predict
			)
		end

		if vim.g.llama_config.show_info == 1 then
			-- display the info in the statusline
			vim.o.statusline = info
			info = ""
		end
	end

	-- display the suggestion and append the info to the end of the first line
	if ghost_text_nvim then
		local virt_text = { { content[1], "llama_hl_hint" } }
		if info ~= "" then
			table.insert(virt_text, { info, "llama_hl_info" })
		end

		vim.api.nvim_buf_set_extmark(bufnr, id_vt_fim, pos_y - 1, pos_x, {
			virt_text = virt_text,
			virt_text_pos = (#content == 1 and content[1] == "") and "eol" or "overlay",
		})

		local virt_lines = {}
		for i = 2, #content do
			table.insert(virt_lines, { { content[i], "llama_hl_hint" } })
		end

		if #virt_lines > 0 then
			vim.api.nvim_buf_set_extmark(bufnr, id_vt_fim, pos_y - 1, 0, {
				virt_lines = virt_lines,
			})
		end
	elseif ghost_text_vim then
		local full_suffix = content[1]
		if full_suffix ~= "" then
			local current_line = vim.api.nvim_buf_get_lines(0, pos_y - 1, pos_y, true)[1] or ""
			local remaining_suffix = string.sub(current_line, pos_x + 1)
			local new_suffix = string.sub(full_suffix, 1, -(#remaining_suffix + 1))
			vim.fn.prop_add(pos_y, pos_x + 1, {
				type = hlgroup_hint,
				text = new_suffix,
			})
		end

		for i = 2, #content do
			vim.fn.prop_add(pos_y, 0, {
				type = hlgroup_hint,
				text = content[i],
				text_padding_left = get_indent(content[i]),
				text_align = "below",
			})
		end

		if info ~= "" then
			vim.fn.prop_add(pos_y, 0, {
				type = hlgroup_info,
				text = info,
				text_wrap = "truncate",
			})
		end
	end

	-- setup accept shortcuts
	vim.keymap.set("i", vim.g.llama_config.keymap_accept_full, function()
		M.fim_accept("full")
	end, { buffer = true })
	vim.keymap.set("i", vim.g.llama_config.keymap_accept_line, function()
		M.fim_accept("line")
	end, { buffer = true })
	vim.keymap.set("i", vim.g.llama_config.keymap_accept_word, function()
		M.fim_accept("word")
	end, { buffer = true })

	hint_shown = true

	fim_data.pos_x = pos_x
	fim_data.pos_y = pos_y
	fim_data.line_cur = line_cur
	fim_data.can_accept = can_accept
	fim_data.content = content
end

-- if accept_type == 'full', accept entire response
-- if accept_type == 'line', accept only the first line of the response
-- if accept_type == 'word', accept only the first word of the response
function M.fim_accept(accept_type)
	local pos_x = fim_data.pos_x
	local pos_y = fim_data.pos_y
	local line_cur = fim_data.line_cur
	local can_accept = fim_data.can_accept
	local content = fim_data.content

	if can_accept and #content > 0 then
		-- insert suggestion on current line
		if accept_type ~= "word" then
			-- insert first line of suggestion
			vim.api.nvim_buf_set_lines(0, pos_y - 1, pos_y, true, { string.sub(line_cur, 1, pos_x) .. content[1] })
		else
			-- insert first word of suggestion
			local suffix = string.sub(line_cur, pos_x + 1)
			local content_without_suffix = string.sub(content[1], 1, -(#suffix + 1))
			local word = vim.fn.matchstr(content_without_suffix, "^\\s*\\S\\+")
			vim.api.nvim_buf_set_lines(0, pos_y - 1, pos_y, true, { string.sub(line_cur, 1, pos_x) .. word .. suffix })
		end

		-- insert rest of suggestion
		if #content > 1 and accept_type == "full" then
			local rest_content = {}
			for i = 2, #content do
				table.insert(rest_content, content[i])
			end
			vim.api.nvim_buf_set_lines(0, pos_y, pos_y, true, rest_content)
		end

		-- move cursor
		if accept_type == "word" then
			-- move cursor to end of word
			local suffix = string.sub(line_cur, pos_x + 1)
			local content_without_suffix = string.sub(content[1], 1, -(#suffix + 1))
			local word = vim.fn.matchstr(content_without_suffix, "^\\s*\\S\\+")
			vim.api.nvim_win_set_cursor(0, { pos_y, pos_x + #word })
		elseif accept_type == "line" or #content == 1 then
			-- move cursor for 1-line suggestion
			vim.api.nvim_win_set_cursor(0, { pos_y, pos_x + #content[1] })
			if #content > 2 then
				-- simulate pressing Enter to move to next line
				vim.fn.feedkeys("\r", "n")
			end
		else
			-- move cursor for multi-line suggestion
			vim.api.nvim_win_set_cursor(0, { pos_y + #content - 1, #content[#content] })
		end
	end

	M.fim_hide()
end

function M.fim_hide()
	hint_shown = false

	-- clear the virtual text
	local bufnr = vim.api.nvim_get_current_buf()

	if ghost_text_nvim then
		local id_vt_fim = vim.api.nvim_create_namespace("vt_fim")
		vim.api.nvim_buf_clear_namespace(bufnr, id_vt_fim, 0, -1)
	elseif ghost_text_vim then
		vim.fn.prop_remove({ type = hlgroup_hint, all = true })
		vim.fn.prop_remove({ type = hlgroup_info, all = true })
	end

	-- remove the mappings
	pcall(vim.keymap.del, "i", vim.g.llama_config.keymap_accept_full, { buffer = true })
	pcall(vim.keymap.del, "i", vim.g.llama_config.keymap_accept_line, { buffer = true })
	pcall(vim.keymap.del, "i", vim.g.llama_config.keymap_accept_word, { buffer = true })
end

-- Enhanced context gathering functions

function M.get_recent_buffers()
	local contexts = {}
	local current_buf = vim.api.nvim_get_current_buf()
	local buffers = vim.tbl_filter(function(buf)
		return vim.api.nvim_buf_is_loaded(buf) and vim.bo[buf].buflisted and buf ~= current_buf
	end, vim.api.nvim_list_bufs())

	-- Sort by last access time (most recent first)
	table.sort(buffers, function(a, b)
		return vim.fn.getbufinfo(a)[1].lastused > vim.fn.getbufinfo(b)[1].lastused
	end)

	-- Take only the configured number of recent buffers to avoid too much context
	for i, buf in ipairs(buffers) do
		if i > vim.g.llama_config.max_recent_buffers then
			break
		end

		local filename = vim.api.nvim_buf_get_name(buf)
		if filename ~= "" then
			local lines = vim.api.nvim_buf_get_lines(buf, 0, vim.g.llama_config.max_buffer_lines, false)
			if #lines > 0 then
				table.insert(contexts, {
					text = table.concat(lines, "\n"),
					type = "recent_buffer",
					filename = filename,
					time = vim.fn.getbufinfo(buf)[1].lastused,
				})
			end
		end
	end

	return contexts
end

return M
