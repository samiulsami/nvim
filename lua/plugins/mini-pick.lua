return {
	"echasnovski/mini.pick",
	lazy = false,
	version = false,
	config = function()
		local mini_pick = require("mini.pick")
		local win_config = function()
			local height = math.floor(0.4 * vim.o.lines)
			local width = math.floor(0.4 * vim.o.columns)
			return {
				anchor = "NW",
				height = height,
				width = width,
				row = math.floor(0.5 * (vim.o.lines - height)),
				col = math.floor(0.5 * (vim.o.columns - width)),
			}
		end

		mini_pick.setup({
			options = { content_from_bottom = false },
			window = { config = win_config },
			mappings = {
				choose_all = {
					char = "<C-q>",
					func = function()
						local matches = mini_pick.get_picker_matches()
						if matches and matches.all and #matches.all > 0 then
							mini_pick.default_choose_marked(matches.all)
						end
					end,
				},
			},
		})
	end,
}
