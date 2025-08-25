return {
	-- "iofq/dart.nvim",
	"samiulsami/dart.nvim",
	branch = "hide-tabline",
	dependencies = { "echasnovski/mini.icons" },
	config = function()
		local dart = require("dart")
		local marklist = { "q", "w", "e", "r", "a", "s", "d", "f" }
		local buflist = {}

		vim.api.nvim_create_autocmd("VimLeavePre", {
			once = true,
			callback = function()
				dart.write_session(vim.fn.sha256(vim.fn.getcwd()))
			end,
		})

		dart.setup({
			marklist = marklist,
			buflist = buflist,

			tabline = {
				always_show = false,
				format_item = function(item)
					local icon = _G.MiniIcons.get("file", item.content)
					local click = string.format("%%%s@SwitchBuffer@", item.bufnr)
					return string.format(
						"%%#%s#%s %s%%#%s#%s %s %%X",
						item.hl_label,
						click,
						item.label,
						item.hl,
						icon,
						item.content
					)
				end,
				order = function()
					local order = {}
					for i, key in ipairs(vim.list_extend(vim.deepcopy(dart.config.marklist), dart.config.buflist)) do
						order[key] = i
					end
					return order
				end,
			},

			mappings = {
				mark = "",
				jump = "",
				pick = "<A-t>",
				next = "",
				prev = "",
				unmark_all = "",
			},
		})

		vim.keymap.set("n", "<leader>a", function()
			local current_buf = vim.api.nvim_get_current_buf()
			local filename = vim.api.nvim_buf_get_name(current_buf)
			local cur_state = dart.state_from_filename(filename)
			if not cur_state or vim.tbl_contains(buflist, cur_state.mark) then
				dart.mark(current_buf)
			else
				local state = dart.state_from_filename(filename)
				if state then
					dart.unmark({ type = "marks", marks = { state.mark } })
				else
					vim.notify("File " .. filename .. " exists in dart but has no mark!", vim.log.levels.WARN)
				end
			end
		end, { noremap = true, silent = true, desc = "Toggle mark on current buffer" })

		vim.keymap.set("n", "<leader>A", function()
			vim.ui.input({ prompt = "[dart] Remove ALL Marks? (y/n) " }, function(input)
				if input and input:lower() == "y" then
					dart.unmark({ type = "all" })
				else
					vim.notify("Aborted removing all marks", vim.log.levels.INFO)
				end
			end)
		end, { noremap = true, silent = true, desc = "Remove ALL Marks" })

		for _, key in ipairs(vim.tbl_deep_extend("force", marklist, buflist)) do
			vim.keymap.set({ "n", "i", "v" }, "<A-" .. key .. ">", function()
				dart.jump(key)
			end, { noremap = true, silent = true, desc = "Jump to marked buffer" })
		end

		vim.api.nvim_set_hl(0, "DartVisible", { fg = "#888899", bold = true })
		vim.api.nvim_set_hl(0, "DartPickLabel", { fg = "#ffffff", bold = true })
		vim.api.nvim_set_hl(0, "DartCurrentModified", { link = "DartCurrent" })
		vim.api.nvim_set_hl(0, "DartCurrentLabelModified", { link = "DartCurrentLabel" })
	end,
}
