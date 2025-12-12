return {
	"nvim-mini/mini.indentscope",
	lazy = false,
	config = function()
		local mini_indentscope = require("mini.indentscope")
		mini_indentscope.setup({
			symbol = "│",
			draw = {
				delay = 0,
				animation = mini_indentscope.gen_animation.none(),
			},
			mappings = {
				object_scope = "",
				object_scope_with_border = "",
				goto_top = "[s",
				goto_bottom = "]s",
			},
			options = {
				border = "both",
				indent_at_cursor = true,
				try_as_border = true,
			},
		})

		vim.keymap.set("n", "s", function()
			local initial_row, initial_col = unpack(vim.api.nvim_win_get_cursor(0))

			---@return boolean
			local try_move = function()
				vim.cmd("normal! m'")
				mini_indentscope.move_cursor("top", true)
				local cur_row, cur_col = unpack(vim.api.nvim_win_get_cursor(0))
				return cur_row ~= initial_row or cur_col ~= initial_col
			end

			if try_move() then
				return
			end

			if initial_col > 0 then
				vim.api.nvim_win_set_cursor(0, { initial_row, initial_col - 1 })
			end
			if try_move() then
				return
			end

			if initial_row > 1 then
				vim.api.nvim_win_set_cursor(0, { initial_row - 1, initial_col })
			end
			if not try_move() then
				vim.notify("Already at the topmost scope", vim.log.levels.WARN)
			end
		end, { desc = "move cursor to top of the scope" })
	end,
}
