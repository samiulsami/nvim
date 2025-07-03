vim.api.nvim_create_user_command("Unique", function(opts)
	local seen = {}
	local start_line = opts.line1
	local end_line = opts.line2
	if start_line > end_line then
		start_line, end_line = end_line, start_line
	end
	local i = start_line

	while i <= end_line do
		local line = vim.fn.getline(i):match("^%s*(.-)%s*$")
		if seen[line] then
			vim.cmd(i .. "delete")
			end_line = end_line - 1
		else
			seen[line] = true
			i = i + 1
		end
	end
end, { range = true, desc = "Remove duplicate lines" })
