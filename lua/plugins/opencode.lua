return {
	"NickvanDyke/opencode.nvim",
	config = function()
		vim.g.opencode_opts = {
			auto_reload = false,
			events = {
				enabled = false,
			},
		}

		local opencode = require("opencode")
		vim.keymap.set("n", "<A-c>", function()
			opencode.ask("@this: ", { clear = false, append = true, submit = false })
		end, { desc = "Ask opencode about this" })

		vim.keymap.set("v", "<A-c>", function()
			opencode.ask("@this: ", { clear = false, append = true, submit = false })
		end, { desc = "Ask opencode about selection" })
	end,
}
