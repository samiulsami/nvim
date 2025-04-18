local cmp = require("cmp")
local source = {}
local protocol = require("vim.lsp.protocol")

source.new = function()
	return setmetatable({}, { __index = source })
end

-- Optional: for filtering when this source activates
source.get_trigger_characters = function()
	return { "." }
end

-- Required: return completion items
source.complete = function(self, request, callback)
	local params = { query = request.context.cursor_before_line }

	vim.lsp.buf_request(0, "workspace/symbol", params, function(_, result, _, _)
		if not result then
			return callback({ items = {}, isIncomplete = false })
		end

		local items = {}
		for _, symbol in ipairs(result) do
			table.insert(items, {
				label = symbol.name,
				kind = protocol.SymbolKind[symbol.kind] or "Unknown",
				detail = "[" .. symbol.containerName .. "]",
				data = symbol,
			})
		end

		callback({ items = items, isIncomplete = false })
	end)
end

function source:resolve(completion_item, callback)
	local symbol = completion_item.data
	if not symbol or not symbol.location then
		return callback(completion_item)
	end

	local path = vim.uri_to_fname(symbol.location.uri)
	local line = symbol.location.range.start.line

	local lines = {}
	local fd = io.open(path, "r")
	if fd then
		for file_line in fd:lines() do
			table.insert(lines, file_line)
		end
		fd:close()
	end

	local docs = {}
	for i = line - 1, 1, -1 do
		local l = lines[i]
		-- if l:match("^%s*//") then
		table.insert(docs, l)
		-- elseif l:match("^%s*$") then
		-- 	-- skip blank lines
		-- else
		-- 	break
		-- end
	end

	if #docs > 0 then
		completion_item.documentation = {
			kind = "markdown",
			value = table.concat(docs, "\n"),
		}
	end

	callback(completion_item)
end

---Executed after the item was selected.
---@param completion_item lsp.CompletionItem
---@param callback fun(completion_item: lsp.CompletionItem|nil)
function source:execute(completion_item, callback)
	callback(completion_item)
end

cmp.register_source("gosymbols", source)

return {}
