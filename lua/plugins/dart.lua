return {
	"iofq/dart.nvim",
	config = function()
		local dart = require("dart")
		local marklist = { "q", "w", "e", "r", "a", "s", "d", "f" }
		local buflist = {}

		dart.setup({
			marklist = marklist,
			buflist = buflist,
			tabline = { always_show = false },

			mappings = {
				mark = "",
				jump = "",
				pick = "<A-t>",
				next = "",
				prev = "",
				unmark_all = "",
			},
		})

		vim.keymap.set("n", "<leader>A", function()
			vim.ui.input({ prompt = "[dart] Remove ALL Marks?" }, function(input)
				if not input then
					vim.notify("Aborted removing all marks", vim.log.levels.INFO)
					return
				end
				if input:match("^%s*(.-)%s*$") then
					dart.unmark({ type = "all" })
				end
			end)
		end, { noremap = true, silent = true, desc = "Remove ALL Marks" })

		for _, key in ipairs(marklist) do
			vim.keymap.set({ "n", "i", "v" }, "<A-" .. key .. ">", function()
				local current_buf = vim.api.nvim_get_current_buf()

				local state_from_filename = dart.state_from_filename(vim.api.nvim_buf_get_name(current_buf))
				local state_from_mark = dart.state_from_mark(key)

				if
					state_from_mark and not (state_from_filename and state_from_filename.mark == state_from_mark.mark)
				then
					dart.jump(key)
				elseif state_from_filename then
					dart.unmark({ type = "marks", marks = { state_from_filename.mark } })
				end

				if not state_from_mark then
					dart.mark(current_buf, key)
				end
			end, { noremap = true, silent = true, desc = "Jump to marked buffer" })
		end

		for _, key in ipairs(buflist) do
			vim.keymap.set({ "n", "i", "v" }, "<A-" .. key .. ">", function()
				dart.jump(key)
			end, { noremap = true, silent = true, desc = "Jump to buffer in list" })
		end

		local current_fg = "#ffffff"
		local visible_fg = "#7777ff"
		vim.api.nvim_set_hl(0, "DartCurrent", { fg = current_fg, bold = true })
		vim.api.nvim_set_hl(0, "DartCurrentLabel", { fg = "orange", bold = true })

		vim.api.nvim_set_hl(0, "DartVisibleLabel", { fg = visible_fg, bold = true })
		vim.api.nvim_set_hl(0, "DartVisible", { fg = visible_fg, bold = true })

		vim.api.nvim_set_hl(0, "DartMarked", { fg = visible_fg, bold = true })
		vim.api.nvim_set_hl(0, "DartMarkedLabel", { fg = visible_fg, bold = true })
		vim.api.nvim_set_hl(0, "DartMarkedLabelModified", { fg = visible_fg, bold = true })
		vim.api.nvim_set_hl(0, "DartMarkedCurrent", { fg = current_fg, bold = true })
		vim.api.nvim_set_hl(0, "DartMarkedCurrentLabel", { fg = "orange", bold = true })
		vim.api.nvim_set_hl(0, "DartMarkedCurrentLabelModified", { fg = "orange", bold = true })

		vim.api.nvim_set_hl(0, "DartPickLabel", { fg = "#ffffff", bold = true })
		vim.api.nvim_set_hl(0, "DartCurrentModified", { link = "DartCurrent" })
		vim.api.nvim_set_hl(0, "DartCurrentLabelModified", { link = "DartCurrentLabel" })

		vim.api.nvim_create_autocmd("VimLeavePre", {
			once = true,
			callback = function()
				dart.write_session(vim.fn.sha256(vim.fn.getcwd()))
			end,
		})

		vim.api.nvim_create_autocmd("VimEnter", {
			callback = function()
				dart.read_session(vim.fn.sha256(vim.fn.getcwd()))
			end,
		})

	end,
}
