--Load all open buffers in the current project into a quickfix list
local project_buffers = function()
	local project_root = vim.fn.getcwd()
	local buffers = vim.api.nvim_list_bufs()
	local project_buffers = {}

	local project_buffer_inclusion_patterns = {
		project_root,
	}

	local project_buffer_exclusion_patterns = {
		-- "neo-tree",
		"Neotest",
	}

	for _, bufnr in ipairs(buffers) do
		local filepath = vim.api.nvim_buf_get_name(bufnr)
		local should_ignore = (filepath == "")

		for _, include_pattern in ipairs(project_buffer_inclusion_patterns) do
			if not filepath:find(include_pattern, 1, true) then
				should_ignore = true
				break
			end
		end

		for _, ignore_pattern in ipairs(project_buffer_exclusion_patterns) do
			if filepath:find(ignore_pattern, 1, true) then
				should_ignore = true
				break
			end
		end

		if not should_ignore then
			table.insert(project_buffers, {
				bufnr = bufnr,
				filename = filepath,
				lnum = 1,
			})
		end
	end

	vim.fn.setqflist({}, " ", { title = "Project Buffers", items = project_buffers })
	vim.cmd("copen")
end

vim.keymap.set("n", "<leader>pb", project_buffers, { noremap = true, silent = true, desc = "[P]roject [B]uffers" })
