return {
	"samiulsami/dart.nvim",
	branch = "persistence",
	dependencies = { "echasnovski/mini.icons" },
	config = function()
		local dart = require("dart")
		local marklist = { "q", "w", "e", "r" }
		local buflist = {} -- { "a", "s", "d", "f" }

		vim.api.nvim_create_autocmd("VimLeavePre", {
			once = true,
			callback = function()
				dart.write_session(vim.fn.sha256(vim.fn.getcwd()))
			end,
		})

		dart.setup({
			marklist = marklist,
			buflist = buflist,

			always_show = false,
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
					for i, key in ipairs(vim.list_extend(vim.deepcopy(Dart.config.marklist), Dart.config.buflist)) do
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
			},
		})

		vim.keymap.set("n", "<leader>a", function()
			require("dart").mark(vim.api.nvim_get_current_buf())
		end, { noremap = true, silent = true, desc = "Mark current buffer" })

		for _, key in ipairs(marklist) do
			vim.keymap.set("n", "<A-" .. key .. ">", function()
				require("dart").jump(key)
			end, { noremap = true, silent = true, desc = "Jump to buffer" })
		end

		for _, key in ipairs(buflist) do
			vim.keymap.set("n", "<A-" .. key .. ">", function()
				require("dart").jump(key)
			end, { noremap = true, silent = true, desc = "Jump to buffer" })
		end

		vim.api.nvim_set_hl(0, "DartVisible", { fg = "#888899", bold = true })
		vim.api.nvim_set_hl(0, "DartPickLabel", { fg = "#ffffff", bold = true })
		vim.api.nvim_set_hl(0, "DartCurrentModified", { link = "DartCurrent" })
		vim.api.nvim_set_hl(0, "DartCurrentLabelModified", { link = "DartCurrentLabel" })
	end,
}
