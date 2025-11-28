return {
	"rmagatti/auto-session",
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
