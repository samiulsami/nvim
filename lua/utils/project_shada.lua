---@class utils.project_shada.Location
---@field path string
---@field row integer?
---@field col integer?
---@field lnum integer?

---@class utils.project_shada.State
---@field shadafile string?
---@field last_buffer_file string?

---@class utils.project_shada.Jump
---@field bufnr integer?
---@field lnum integer?
---@field col integer?

---@class utils.project_shada
---@field restore fun(): nil
---@field save fun(): nil
---@field restore_last_buffer fun(): boolean
---@field setup fun(): utils.project_shada
local M = {}

---@type utils.project_shada.State
local state = {}

---@param path string?
---@return string?
local function normalize(path)
	if type(path) ~= "string" or path == "" then
		return nil
	end

	path = vim.fn.fnamemodify(path, ":p")
	return vim.uv.fs_realpath(path) or path
end

---@param path string
---@return string
local function encode(path)
	return (path:gsub("[^%w%._%-]", function(char)
		return string.format("%%%02X", string.byte(char))
	end))
end

---@param path string?
---@return string?
local function existing_file(path)
	path = normalize(path)
	return path and vim.fn.filereadable(path) == 1 and path or nil
end

---@param bufnr integer
---@return boolean
local function is_persistable_buffer(bufnr)
	if vim.api.nvim_get_option_value("buftype", { buf = bufnr }) ~= "" then
		return false
	end

	if vim.api.nvim_buf_get_name(bufnr) == "" then
		return false
	end

	return existing_file(vim.api.nvim_buf_get_name(bufnr)) ~= nil
end

---@return utils.project_shada.Location?
local function current_location()
	local bufnr = vim.api.nvim_get_current_buf()
	if not is_persistable_buffer(bufnr) then
		return nil
	end

	local path = existing_file(vim.api.nvim_buf_get_name(bufnr))
	local cursor = vim.api.nvim_win_get_cursor(0)
	return { path = path, row = cursor[1], col = cursor[2] }
end

---@param location utils.project_shada.Location?
---@return boolean
local function open_location(location)
	local path = existing_file(location and location.path)
	if not path then
		return false
	end

	local ok = pcall(vim.cmd, "silent keepjumps edit! " .. vim.fn.fnameescape(path))
	if not ok then
		return false
	end

	pcall(vim.api.nvim_win_set_cursor, 0, {
		math.max(location.row or location.lnum or 1, 1),
		math.max(location.col or 0, 0),
	})
	return true
end

---@return nil
local function save_last_buffer()
	if not state.last_buffer_file then
		return
	end

	vim.fn.writefile({ vim.json.encode(current_location()) }, state.last_buffer_file)
end

---@return utils.project_shada.Location?
local function load_last_buffer()
	if not state.last_buffer_file then
		return nil
	end

	if vim.fn.filereadable(state.last_buffer_file) == 0 then
		return nil
	end

	local ok, location = pcall(vim.json.decode, table.concat(vim.fn.readfile(state.last_buffer_file), "\n"))
	---@cast location utils.project_shada.Location?
	return ok and type(location) == "table" and location or nil
end

---@return boolean
local function last_valid_jump()
	---@type utils.project_shada.Jump[], integer
	local jumplist, index = unpack(vim.fn.getjumplist())

	for i = math.min(index + 1, #jumplist), 1, -1 do
		---@type utils.project_shada.Jump
		local jump = jumplist[i]
		if open_location({
			path = vim.fn.bufname(jump.bufnr or -1),
			lnum = jump.lnum,
			col = jump.col,
		}) then
			return true
		end
	end

	return false
end

---@return nil
function M.restore()
	vim.cmd("silent! rshada!")
end

---@return nil
function M.save()
	vim.cmd("silent! wshada!")
end

---@return boolean
function M.restore_last_buffer()
	return open_location(load_last_buffer()) or last_valid_jump()
end

---@return utils.project_shada
function M.setup()
	if state.shadafile then
		return M
	end

	local root = vim.fn.stdpath("state")
	local cwd = normalize(vim.fn.getcwd()) or vim.fn.getcwd()
	local key = encode(cwd)

	vim.fn.mkdir(root .. "/project-shada", "p")
	vim.fn.mkdir(root .. "/project-state", "p")

	state.shadafile = root .. "/project-shada/" .. key .. ".shada"
	state.last_buffer_file = root .. "/project-state/" .. key .. ".json"

	vim.opt.shadafile = state.shadafile
	vim.api.nvim_create_autocmd("VimLeavePre", {
		group = vim.api.nvim_create_augroup("ProjectShada", { clear = true }),
		callback = function()
			save_last_buffer()
			M.save()
		end,
	})

	return M
end

return M
