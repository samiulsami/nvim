---@class utils.notifications
---@field private notifications table<string>
---@field private head integer
---@field private tail integer
---@field private max_notifications integer
---@field private unseen_notifications integer
---@field private preview string
---@field private max_preview_length integer
---@field private max_level integer
---@field public get_unseen_notification_stats fun(self): integer, string, integer
---@field public reset_unseen_notifications fun(self): nil
---@field public get_notifications fun(self): table<string>, integer, integer notifications, head, tail
local M = {
	notifications = {},
	head = 1,
	tail = 0,
	max_notifications = 100,
	unseen_notifications = 0,
	max_level = 0,
	max_preview_length = 16,
}

function M:get_unseen_notification_stats()
	return self.unseen_notifications, self.preview, self.max_level
end

function M:reset_unseen_notifications()
	self.unseen_notifications = 0
	self.max_level = 0
	self.preview = ""
end

function M:get_notifications()
	return self.notifications, self.head, self.tail
end

M.setup = function()
	---@diagnostic disable-next-line: duplicate-set-field
	vim.notify = function(msg, level, _)
		local timestamp = os.date("%Y-%m-%d %H:%M:%S")
		M.unseen_notifications = math.min(M.unseen_notifications + 1, M.max_notifications)
		M.tail = M.tail + 1

		if not level then
			level = vim.log.levels.INFO
		end

		if level >= M.max_level then
			M.max_level = level
			M.preview = msg
			if #msg > M.max_preview_length then
				M.preview = M.preview:sub(1, math.max(0, M.max_preview_length - 3)) .. "..."
			end
		end

		local level_str = "INFO"
		if level == vim.log.levels.ERROR then
			level_str = "ERROR"
		elseif level == vim.log.levels.WARN then
			level_str = "WARN"
		elseif level == vim.log.levels.INFO then
			level_str = "INFO"
		elseif level == vim.log.levels.TRACE then
			level_str = "TRACE"
		elseif level == vim.log.levels.DEBUG then
			level_str = "DEBUG"
		end

		---FIXME: can probably be done better with regexes
		M.notifications[M.tail] = vim.fn
			.json_encode({ timestamp = timestamp, msg = msg, level = level_str })
			:gsub("\n", "")
			:gsub("\t", "")
			:gsub("\r", "")
			:gsub("\\", "")

		while M.tail - M.head + 1 > M.max_notifications do
			M.notifications[M.head] = nil
			M.head = M.head + 1
		end

		local ok, lualine = pcall(require, "lualine")
		if ok then
			lualine.refresh()
		end
	end
end

return M
