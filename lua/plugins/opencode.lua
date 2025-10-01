return {
	"NickvanDyke/opencode.nvim",
	---@type opencode.Opts
	opts = {
		auto_reload = true,
		on_send = function()
			vim.notify("Sent request to Opencode instance in " .. vim.fn.getcwd(), vim.log.levels.INFO)
		end,
		on_opencode_not_found = function()
			return false
		end,
	},
	keys = {
		{
			"<A-c>",
			function()
				require("opencode").ask("@cursor: ", { clear = false, append = true, submit = false })
			end,
			desc = "Ask opencode about this",
			mode = "n",
		},
		{
			"<A-c>",
			function()
				require("opencode").ask("@selection: ", { clear = false, append = true, submit = false })
			end,
			desc = "Ask opencode about selection",
			mode = "v",
		},
	},
}
