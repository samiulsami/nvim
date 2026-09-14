---@type PluginSpec
return {
	src = "https://github.com/kawre/leetcode.nvim",
	deps = {
		{ src = "https://github.com/nvim-lua/plenary.nvim" },
		{ src = "https://github.com/MunifTanjim/nui.nvim" },
	},
	config = function()
		require("leetcode").setup({
			lang = "cpp",
			plugins = {
				non_standalone = true,
			},
			description = {
				position = "left",
				width = "40%",
				show_stats = true,
			},
			picker = {
				provider = "fzf-lua",
			},
		})

		vim.keymap.set("n", "<leader>cl", "<Cmd>Leet<CR>", { desc = "Open LeetCode" })
	end,
}
