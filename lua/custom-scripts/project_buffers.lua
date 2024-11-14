--Load all open buffers in the current project into a quickfix list
local project_buffers = function()
	local project_root = vim.fn.getcwd()
	local buffers = vim.api.nvim_list_bufs()
	local project_buffers = {}

	for _, bufnr in ipairs(buffers) do
		local filepath = vim.api.nvim_buf_get_name(bufnr)
		if
			filepath ~= ""
			and filepath:find(project_root, 1, true)
			and not filepath:find("neo-tree filesystem", 1, true)
		then
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
