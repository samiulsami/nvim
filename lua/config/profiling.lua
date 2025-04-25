-- source: https://www.reddit.com/r/neovim/comments/17a4m8q/comment/k5elu28/

vim.keymap.set("n", "<leader><C-p>", function()
	vim.cmd([[
		:profile start /tmp/nvim-profile.log
		:profile func *
		:profile file *
	]])
	vim.notify("Profiling started")
end, { desc = "Profile Start" })

vim.keymap.set("n", "<leader><C-e>", function()
	vim.cmd([[
		:profile stop
		:e /tmp/nvim-profile.log
	]])
	vim.notify("Profiling stopped")
end, { desc = "Profile End" })
