local M = {}

---@enum Direction
M.direction = {
	LEFT = "left",
	DOWN = "down",
	UP = "up",
	RIGHT = "right",
}

local direction_map = {
	[M.direction.LEFT] = { vim = "h", tmux = "L" },
	[M.direction.DOWN] = { vim = "j", tmux = "D" },
	[M.direction.UP] = { vim = "k", tmux = "U" },
	[M.direction.RIGHT] = { vim = "l", tmux = "R" },
}

---@param winid number?
---@return boolean
local function is_floating(winid)
	local config = vim.api.nvim_win_get_config(winid or 0)
	return config.relative ~= nil and config.relative ~= ""
end

---@return number?
local function get_previous_window()
	local prev_win = vim.fn.win_getid(vim.fn.winnr("#"))
	if prev_win ~= 0 and vim.api.nvim_win_is_valid(prev_win) and not is_floating(prev_win) then
		return prev_win
	end
	return nil
end

---@param tmux_flag string
local function navigate_tmux(tmux_flag)
	vim.fn.system("tmux select-pane -" .. tmux_flag)
	if vim.v.shell_error ~= 0 then
		vim.notify("Failed to move to tmux pane", vim.log.levels.ERROR)
	end
end

---@param direction Direction
function M.move_or_tmux(direction)
	local mapping = direction_map[direction]
	if not mapping then
		vim.notify("Invalid direction: " .. tostring(direction), vim.log.levels.ERROR)
		return
	end

	local float_win = nil

	if is_floating() then
		float_win = vim.api.nvim_get_current_win()
		local underlying = get_previous_window()
		if not underlying then
			navigate_tmux(mapping.tmux)
			return
		end
		vim.api.nvim_set_current_win(underlying)
	end

	local current_win = vim.api.nvim_get_current_win()
	vim.cmd("wincmd " .. mapping.vim)
	if current_win ~= vim.api.nvim_get_current_win() then
		return
	end

	-- restore floating window
	if float_win and vim.api.nvim_win_is_valid(float_win) then
		vim.api.nvim_set_current_win(float_win)
	end
	navigate_tmux(mapping.tmux)
end

---@param direction Direction
---@param amount number?
function M.resize(direction, amount)
	amount = amount or 4
	local cmd_map = {
		[M.direction.UP] = "resize +" .. amount,
		[M.direction.DOWN] = "resize -" .. amount,
		[M.direction.LEFT] = "vertical resize -" .. amount,
		[M.direction.RIGHT] = "vertical resize +" .. amount,
	}

	local cmd = cmd_map[direction]
	if not cmd then
		vim.notify("Invalid direction: " .. tostring(direction), vim.log.levels.ERROR)
		return
	end

	vim.cmd(cmd)
end

function M.setup_keymaps()
	if M.keymaps_set then
		vim.notify("[tmux navigation] keymaps already set", vim.log.levels.ERROR)
		return
	end
	M.keymaps_set = true

	vim.keymap.set({ "n", "t" }, "<C-h>", function()
		M.move_or_tmux(M.direction.LEFT)
	end, { noremap = true, silent = true })

	vim.keymap.set({ "n", "t" }, "<C-j>", function()
		M.move_or_tmux(M.direction.DOWN)
	end, { noremap = true, silent = true })

	vim.keymap.set({ "n", "t" }, "<C-k>", function()
		M.move_or_tmux(M.direction.UP)
	end, { noremap = true, silent = true })

	vim.keymap.set({ "n", "t" }, "<C-l>", function()
		M.move_or_tmux(M.direction.RIGHT)
	end, { noremap = true, silent = true })

	vim.keymap.set({ "n", "t" }, "<A-k>", function()
		M.resize(M.direction.UP)
	end, { noremap = true, silent = true })

	vim.keymap.set({ "n", "t" }, "<A-j>", function()
		M.resize(M.direction.DOWN)
	end, { noremap = true, silent = true })

	vim.keymap.set({ "n", "t" }, "<A-h>", function()
		M.resize(M.direction.LEFT)
	end, { noremap = true, silent = true })

	vim.keymap.set({ "n", "t" }, "<A-l>", function()
		M.resize(M.direction.RIGHT)
	end, { noremap = true, silent = true })
end

return M
