---@type PluginSpec
return {
	src = "https://github.com/kylechui/nvim-surround",
	version = vim.version.range("*"),
	config = function()
		require("nvim-surround").setup({
			-- Configuration here, or leave empty to use defaults
		})
	end,
}
