---@type PluginSpec
return {
	src = "https://github.com/vague-theme/vague.nvim",
	config = function()
		vim.cmd("colorscheme vague")
		require("utils.default_colors").set_colors()
	end,
}
