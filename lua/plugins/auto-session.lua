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
		lazy_support = true,
		use_git_branch = true,
		restore_error_handler = function(error_msg)
			vim.notify(error_msg, vim.log.levels.ERROR)
			return true
		end,
	},
	--stylua: ignore
	keys = {
		{"<leader>ss", ":SessionSearch<CR>", desc = "Search sessions"},
	}
,
}
