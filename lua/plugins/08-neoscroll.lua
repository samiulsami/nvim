---@type PluginSpec
return {
	src = "https://github.com/karb94/neoscroll.nvim",
	config = function()
		local neoscroll = require("neoscroll")

		neoscroll.setup({
			mappings = {},
			post_hook = function(info)
				if info == "center" then
					vim.cmd("normal! zz")
				end
			end,
		})

		vim.keymap.set("n", "<C-d>", function()
			neoscroll.ctrl_d({ duration = 0, info = "center" })
		end, { noremap = true, silent = true, desc = "Smooth scroll down and center" })
		vim.keymap.set("n", "<C-u>", function()
			neoscroll.ctrl_u({ duration = 0, info = "center" })
		end, { noremap = true, silent = true, desc = "Smooth scroll up and center" })
	end,
}
