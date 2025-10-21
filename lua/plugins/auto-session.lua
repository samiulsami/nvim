return {
	"rmagatti/auto-session",
	lazy = false,
	---enables autocomplete for opts
	---@module "auto-session"
	---@type AutoSession.Config
	opts = {
		enabled = true,
		auto_save = true,
		auto_restore = false,
		suppressed_dirs = { "~/", "/tmp", "~/Downloads", "/" },
	},
}
