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
		"LennyPhoenix/project.nvim",
		commit = "6f1937d134515adb7302e3847981063842a65c8b",
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
