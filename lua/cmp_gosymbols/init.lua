local cmp = require("cmp")
local source = {}

-- Helper function to check if inside an import block (already updated)
local check_if_inside_imports = function()
	local cur_node = require("nvim-treesitter.ts_utils").get_node_at_cursor()
	local is_in_string = false

	while cur_node do
		local node_type = cur_node:type()

		if node_type == "interpreted_string_literal" then
			is_in_string = true
		end

		if node_type == "import_declaration" then
			return is_in_string
		end

		cur_node = cur_node:parent()
	end

	return false
end

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
			local alias = symbol.containerName:match("([^/]+)$") or "A"
			local import_stmt = string.format('%s "%s"', alias, symbol.containerName)

			-- Add items to completion list
			table.insert(items, {
				label = symbol.name,
				kind = symbol.kind,
				detail = symbol.containerName,
				documentation = symbol.location.uri,
				sortText = "z" .. symbol.name,

				-- Resolve function for inserting import or usage
				resolve = function(completion_item, resolve_callback)
					if check_if_inside_imports() then
						-- Inside import block: Insert import statement
						completion_item.insertText = import_stmt
					else
						-- Outside import block: Insert symbol with alias
						completion_item.insertText = alias .. "." .. symbol.name
					end

					resolve_callback(completion_item)
				end,

				-- Insert symbol content on selection
				insertTextFormat = 1, -- PlainText
			})
		end

		callback({ items = items, isIncomplete = false })
	end)
end

cmp.register_source("gosymbols", source)

return {}
