---@type PackSpec
return {
	src = "/home/sami/.local/share/nvim/site/pack/core/opt/cmp-go-deep",
	deps = {
		{ src = "https://github.com/kkharji/sqlite.lua" },
	},
	config = function()
		require("cmp_go_deep").setup({
			notifications = true,
			debounce_gopls_requests_ms = 75,
			native_min_keyword_length = 2,
			native_max_items = 20,
		})
	end,
}
