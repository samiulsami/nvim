-- source: https://www.reddit.com/r/neovim/comments/17a4m8q/comment/k5elu28/

vim.keymap.set("n", "<leader>PS", function()
	vim.cmd([[
		:profile start /tmp/nvim-profile.log
		:profile func *
		:profile file *
	]])
end, { desc = "Profile Start" })

vim.keymap.set("n", "<leader>PE", function()
	vim.cmd([[
		:profile stop
		:e /tmp/nvim-profile.log
	]])
end, { desc = "Profile End" })
