return {
	"rmagatti/auto-session",
	lazy = false,
	---enables autocomplete for opts
	---@module "auto-session"
	---@type AutoSession.Config
	opts = {
		suppressed_dirs = { "~/", "~/Projects", "~/Downloads", "/" },
		cwd_change_handling = true,
		continue_restore_on_error = true,
		show_auto_restore_notif = true,
	},
	--stylua: ignore
	keys = {
		{"<leader>ss", ":SessionSearch<CR>", desc = "Search sessions"},
	}
,
}
