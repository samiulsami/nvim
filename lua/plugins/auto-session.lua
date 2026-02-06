return {
	spec = {
		{ src = "https://github.com/rmagatti/auto-session" },
	},
	config = function()
		require("auto-session").setup({
			enabled = true,
			auto_save = true,
			auto_restore = false,
			suppressed_dirs = { "~/", "/tmp", "~/Downloads", "/" },
			pre_save_cmds = { "clearjumps" },
		})
	end,
}
