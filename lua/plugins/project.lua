return {
	--[[
          n | i 	Action

          f	<c-f>	find_project_files
          b	<c-b>	browse_project_files
          d	<c-d>	delete_project
          s	<c-s>	search_in_project_files
          r	<c-r>	recent_project_files
          w	<c-w>	change_working_directory
    ]]
	{
		"DrKJeff16/project.nvim",
		branch = "jeff",
		commit = "2aa7f746a6a048738eace3f1c9e834243b9faad6",
		config = function()
			require("project_nvim").setup({
				manual_mode = false,
				detection_methods = { "pattern", "lsp" },
				patterns = { ".git", "_darcs", ".hg", ".bzr", ".svn", "Makefile", "package.json" },
				ignore_lsp = {},
				exclude_dirs = {},
				show_hidden = true,
				silent_chdir = false,
				scope_chdir = "global",
				datapath = vim.fn.stdpath("data"),
			})
		end,
	},
}
