local file_path = vim.fn.expand("%:p")

local segments = {}
local function split_string(str, delimiter)
	local result = {}
	local from = 1
	local delim_from, delim_to = string.find(str, delimiter, from)

	while delim_from do
		tmp = string.sub(str, from, delim_from - 1)
		table.insert(result, tmp)
		from = delim_to + 1
		delim_from, delim_to = string.find(str, delimiter, from)
	end

	table.insert(result, string.sub(str, from)) -- Insert the last part
	return result
end

segments = split_string(file_path, "/")
for _, i in ipairs(segments) do
	print(i .. "\n")
end
