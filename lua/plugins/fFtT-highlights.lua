return {
	"samiulsami/fFtT-highlights.nvim",
	config = function()
		---@module "fFtT-highlights"
		---@type fFtT_highlights.opts
		require("fFtT-highlights"):setup({
			on_reset = function()
				vim.cmd.nohlsearch()
			end,
			-- case_sensitivity = "smart_case",
			match_highlight = {
				priority = 2000,
			},
			backdrop = {
				style = {
					show_in_motion = "current_line",
					on_key_press = "current_line",
				},
			},
			jumpable_chars = {
				show_instantly_jumpable = "always",
				show_all_jumpable_in_words = "on_key_press",
                                show_secondary_jumpable = "on_key_press",
				min_gap = 0,
			},
			disabled_buftypes = {},
			disabled_filetypes = { "oil", "yazi", "fugitive", "lazy" },
		})
	end,
}
