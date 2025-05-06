return {
	"rmagatti/auto-session",
	event = "VimEnter",
	---@module "auto-session"
	---@type AutoSession.Config
	opts = {
		suppressed_dirs = { "~/", "~/Projects", "~/Downloads", "/" },
		cwd_change_handling = false,
		continue_restore_on_error = false,
		show_auto_restore_notif = false,
	},
	--stylua: ignore
	keys = {
		{"<leader>ss", ":SessionSearch<CR>", desc = "Search sessions"},
	}
,
}
