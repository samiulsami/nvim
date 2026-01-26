return {
	"TheNoeTrevino/haunt.nvim",
	-- default config: change to your liking, or remove it to use defaults
	---@class HauntConfig
	opts = {
		sign = "󱙝",
		sign_hl = "DiagnosticInfo",
		virt_text_hl = "HauntAnnotation",
		annotation_prefix = " 󰆉 ",
		line_hl = nil,
		virt_text_pos = "eol",
		data_dir = nil,
		picker_keys = {
			delete = { key = "ctrl-d", mode = { "n" } },
			edit_annotation = { key = "ctrl-a", mode = { "n" } },
		},
	},
	-- recommended keymaps, with a helpful prefix alias
	init = function()
		local haunt = require("haunt.api")
		local haunt_store = require("haunt.store")
		local haunt_display = require("haunt.display")
		local jump_keys = { "q", "w", "e", "r" }

		vim.keymap.set("n", "<A-a>", function()
			local current_buf = vim.api.nvim_get_current_buf()
			local filename = vim.api.nvim_buf_get_name(current_buf)
			local cursor_row = vim.api.nvim_win_get_cursor(0)[1]
			local bookmark, _ = haunt_store.get_bookmark_at_line(filename, cursor_row)
			if bookmark == nil then
				haunt.annotate()
				return
			end
			haunt_store.remove_bookmark(bookmark)
			haunt_display.delete_bookmark_mark(current_buf, bookmark.annotation_extmark_id)
			haunt_display.unplace_sign(current_buf, bookmark.extmark_id)
			haunt_store.save()
		end, { desc = "Toggle annotation" })

		for i, key in ipairs(jump_keys) do
			vim.keymap.set("n", "<A-" .. key .. ">", function()
				local index = i
				local bookmarks = haunt.get_bookmarks()

				if #bookmarks == 0 or index > #bookmarks then
					vim.notify("haunt.nvim: no annotation at index " .. index, vim.log.levels.INFO)
					return
				end

				table.sort(bookmarks, function(a, b)
					if a.file == b.file then
						if a.line == b.line then
							return a.note < b.note
						end
						return a.line < b.line
					end
					return a.file < b.file
				end)

				local bookmark = bookmarks[index]
				if bookmark.file and bookmark.line then
					if vim.api.nvim_buf_get_name(0) ~= bookmark.file then
						vim.cmd("edit " .. bookmark.file)
					end
					vim.api.nvim_win_set_cursor(0, { bookmark.line, 0 })
				end
			end, { desc = "Jump to annotation " .. i })
		end

		vim.keymap.set("n", "<A-s>", function()
			require("haunt.picker").show()
		end, { desc = "Show Picker" })

		vim.keymap.set("n", "<leader>A", function()
			haunt.clear_all()
		end, { desc = "Clear all annotations" })
	end,
}
