--TODO: Automate this and integrate with LSP

function Copy_project_relative_path()
	local current_dir = vim.fn.expand("%:p:h")

	local segments = {}
	for segment in string.gmatch(current_dir, "[^/]+") do
		table.insert(segments, segment)
	end

	local projectDirName = nil
	local curPath = nil
	local projectPathStartPos = 0

	for _, s in pairs(segments) do
		if curPath then
			curPath = curPath .. "/" .. s
		else
			curPath = "/" .. s
		end
		if vim.fn.isdirectory(curPath .. "/.git") == 1 then
			projectDirName = s
			projectPathStartPos = #curPath - #s + 1
			break
		end
	end

	if projectDirName == nil or projectPathStartPos <= 0 or projectPathStartPos > #current_dir then
		vim.notify("failed to identify project dir\ncurrent dir: " .. current_dir, vim.log.levels.ERROR)
		return
	end

	local strippedPath = string.sub(current_dir, projectPathStartPos)
	vim.fn.setreg("+", '"' .. strippedPath .. '"')
	vim.notify("Package path '" .. strippedPath .. "' copied to clipboard", vim.log.levels.INFO)
end

vim.api.nvim_set_keymap(
	"n",
	"<leader>cP",
	":lua Copy_project_relative_path()<CR>",
	{ noremap = true, silent = true, desc = "[C]opy trimmed [P]ath" }
)

vim.keymap.set("n", "<leader>cp", function()
	local directory_path = vim.fn.expand("%:p:h")
	vim.fn.setreg("+", '"' .. directory_path .. '"')
	vim.notify('"' .. directory_path .. '" copied to clipboard', vim.log.levels.INFO)
end, { noremap = true, silent = true, desc = "[C]opy [P]ath" })
