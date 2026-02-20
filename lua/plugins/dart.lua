return {
	"iofq/dart.nvim",
	lazy = false,
	config = function()
		local dart = require("dart")
		local marklist = { "q", "w", "e", "r" }
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
			dart.unmark({ type = "all" })
		end, { noremap = true, silent = true, desc = "Remove ALL Marks" })

		-- Upon pressing Alt+key:
		-- if current buffer is unmarked, mark it with 'key'.
		-- if current buffer is marked with 'key', unmark it.
		for _, key in ipairs(marklist) do
			vim.keymap.set({ "n", "i", "v" }, "<A-" .. key .. ">", function()
				local current_buf = vim.api.nvim_get_current_buf()

				local state_from_filename = dart.state_from_filename(vim.api.nvim_buf_get_name(current_buf))
				local state_from_mark = dart.state_from_mark(key)

				if
					state_from_mark and not (state_from_filename and state_from_filename.mark == state_from_mark.mark)
				then
					dart.jump(key)
					return
				end

				if state_from_filename and state_from_mark and state_from_filename.mark == state_from_mark.mark then
					dart.unmark({ type = "marks", marks = { state_from_filename.mark } })
					return
				end

				if not state_from_mark and not state_from_filename then
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
		for _, current in ipairs({
			"DartMarkedCurrent",
			"DartCurrentModified",
			"DartMarkedCurrentModified",
		}) do
			vim.api.nvim_set_hl(0, current, { link = "DartCurrent" })
		end

		vim.api.nvim_set_hl(0, "DartCurrentLabel", { fg = "orange", bold = true })
		for _, current_label in ipairs({
			"DartCurrentLabelModified",
			"DartMarkedCurrentLabel",
			"DartMarkedCurrentLabelModified",
		}) do
			vim.api.nvim_set_hl(0, current_label, { link = "DartCurrentLabel" })
		end

		vim.api.nvim_set_hl(0, "DartVisible", { fg = visible_fg, bold = true })
		for _, visible in ipairs({
			"DartVisibleModified",
			"DartMarkedVisible",
			"DartMarkedVisibleModified",
			"DartMarked",
			"DartMarkedModified",
		}) do
			vim.api.nvim_set_hl(0, visible, { link = "DartVisible" })
		end

		vim.api.nvim_set_hl(0, "DartVisibleLabel", { fg = visible_fg, bold = true })
		for _, visible_label in ipairs({
			"DartVisibleLabelModified",
			"DartMarkedLabel",
			"DartMarkedLabelModified",
		}) do
			vim.api.nvim_set_hl(0, visible_label, { link = "DartVisibleLabel" })
		end

		vim.api.nvim_set_hl(0, "DartPickLabel", { fg = "#ffffff", bold = true })

		local cwd_hash = vim.fn.sha256(vim.fn.getcwd())
		vim.api.nvim_create_autocmd("VimLeavePre", {
			once = true,
			callback = function()
				dart.write_session(cwd_hash)
			end,
		})

		vim.api.nvim_create_autocmd("VimEnter", {
			callback = function()
				vim.schedule(function()
					dart.read_session(cwd_hash)
				end)
			end,
		})
	end,
}
