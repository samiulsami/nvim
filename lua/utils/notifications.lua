---@class utils.notifications
---@field private notifications table<string>
---@field private head integer
---@field private tail integer
---@field private max_notifications integer
---@field private unseen_notifications integer
---@field private preview string
---@field private max_preview_length integer
---@field private max_found_level integer
---@field private buf_name string
---@field public get_unseen_notification_stats fun(self): integer, string, integer
---@field public reset_unseen_notifications fun(self): nil
---@field public get_notifications fun(self): table<string>, integer, integer notifications, head, tail
local M = {
	buf_name = "custom_notifications",
	notifications = {},
	head = 1,
	tail = 0,
	max_notifications = 100,
	unseen_notifications = 0,
	max_found_level = 0,
	max_preview_length = 16,
}

function M:get_unseen_notification_stats()
	return self.unseen_notifications, self.preview, self.max_found_level
end

function M:reset_unseen_notifications()
	self.unseen_notifications = 0
	self.max_found_level = 0
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

		if level >= M.max_found_level then
			M.max_found_level = level
		end

		M.preview = msg
		if #msg > M.max_preview_length then
			M.preview = M.preview:sub(1, math.max(0, M.max_preview_length - 3)) .. "..."
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
		M.notifications[M.tail] = vim.json
			.encode({
				timestamp = timestamp,
				msg = vim.json.encode(msg),
				level = level_str,
			})
			:gsub([[\n]], "")
			:gsub([[\t]], "")
			:gsub([[\r]], "")
			:gsub([[\"]], "'")
			:gsub([[\]], "")

		while M.tail - M.head + 1 > M.max_notifications do
			M.notifications[M.head] = nil
			M.head = M.head + 1
		end

		local ok, lualine = pcall(require, "lualine")
		if ok then
			lualine.refresh()
		end
	end

	---@diagnostic disable-next-line: duplicate-set-field
	vim.print = function(...)
		local args = table.concat(vim.tbl_map(vim.inspect, { ... }), " ")
		vim.notify(args, vim.log.levels.INFO)
	end

	---@diagnostic disable-next-line: duplicate-set-field
	vim.api.nvim_echo = function(msg, _, _)
		vim.notify(
			table.concat(
				vim.tbl_map(function(item)
					return item[1]
				end, msg),
				""
			),
			vim.log.levels.INFO
		)
	end

	local orig_diag_set = vim.diagnostic.set
	---@diagnostic disable-next-line: duplicate-set-field
	vim.diagnostic.set = function(ns, bufnr, diagnostics, opts)
		local ok, err = pcall(orig_diag_set, ns, bufnr, diagnostics, opts)
		if not ok then
			vim.notify("Diagnostic error: " .. vim.inspect({
				diagnostics = table.concat(
					vim.tbl_map(function(item)
						return item.message
					end, diagnostics),
					"\n"
				),
				err = err,
			}), vim.log.levels.ERROR)
		end
	end

	M:setup_keymaps()

	vim.api.nvim_create_autocmd("BufLeave", {
		pattern = M.buf_name,
		callback = function()
			vim.api.nvim_buf_delete(0, { force = true })
		end,
	})
end

function M:setup_keymaps()
	vim.keymap.set("n", "<M-n>", function()
		local current_buffer = vim.api.nvim_get_current_buf()
		if self.buf_name == vim.fn.bufname(current_buffer) then
			vim.api.nvim_buf_delete(current_buffer, { force = true })
			return
		end

		local buf = vim.api.nvim_create_buf(false, true)
		local notifications, head, tail = self:get_notifications()
		if not notifications then
			return
		end

		local all_lines = {}
		local jq_available = vim.fn.executable("jq")

		if not jq_available then
			vim.notify("jq is not installed, displaying raw notifications", vim.log.levels.WARN)
		end

		for i = tail, head, -1 do
			if not jq_available then
				table.insert(all_lines, notifications[i])
				table.insert(all_lines, "")
				goto continue
			end
			local output = vim.fn.system("jq", notifications[i])
			local notification = notifications[i]
			if vim.v.shell_error == 0 then
				notification = output
			end
			for line in notification:gmatch("[^\r\n]+") do
				table.insert(all_lines, line)
			end
			table.insert(all_lines, "")

			::continue::
		end

		vim.api.nvim_buf_set_lines(buf, 0, -1, false, all_lines)
		vim.api.nvim_set_current_buf(buf)
		vim.cmd("setlocal ft=json wrap")
		pcall(vim.api.nvim_buf_set_name, buf, self.buf_name)

		vim.api.nvim_set_hl(0, "NotificationError", { fg = "red", bold = true })
		vim.api.nvim_set_hl(0, "NotificationWarning", { fg = "yellow", bold = true })
		vim.api.nvim_set_hl(0, "NotificationInfo", { fg = "green" })
		vim.api.nvim_set_hl(0, "NotificationDebug", { fg = "blue" })
		vim.api.nvim_set_hl(0, "NotificationTrace", { fg = "gray" })

		vim.fn.matchadd("NotificationError", '.*"level":[[:space:]]*"ERROR".*')
		vim.fn.matchadd("NotificationWarning", '.*"level":[[:space:]]*"WARN".*')
		vim.fn.matchadd("NotificationInfo", '.*"level":[[:space:]]*"INFO".*')
		vim.fn.matchadd("NotificationDebug", '.*"level":[[:space:]]*"DEBUG".*')
		vim.fn.matchadd("NotificationTrace", '.*"level":[[:space:]]*"TRACE".*')

		self:reset_unseen_notifications()
	end, { desc = "Show notifications", noremap = true, silent = true })
end

return M
