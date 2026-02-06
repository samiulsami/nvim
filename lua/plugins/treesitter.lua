return {
	spec = {
		{ src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "main" },
	},
	build = ":TSUpdate",
	config = function()
		vim.filetype.add({
			extension = {
				gotmpl = "gotmpl",
			},
			pattern = {
				[".*/templates/.*%.tpl"] = "helm",
				[".*/templates/.*%.ya?ml"] = "helm",
				["helmfile.*%.ya?ml"] = "helm",
			},
		})

		require("nvim-treesitter").install({
			"bash",
			"zsh",
			"fish",
			"tmux",
			"editorconfig",
			"ssh_config",
			"ini",
			"diff",
			"dockerfile",
			"c",
			"cpp",
			"diff",
			"html",
			"lua",
			"luadoc",
			"json",
			"yaml",
			"make",
			"markdown",
			"markdown_inline",
			"query",
			"vim",
			"vimdoc",
			"go",
			"gomod",
			"gosum",
			"gotmpl",
			"gowork",
			"git_config",
			"git_rebase",
			"gitattributes",
			"gitcommit",
			"gitignore",
			"java",
			"scala",
			"latex",
			"gotmpl",
			"helm",
		})

		vim.api.nvim_create_autocmd("FileType", {
			callback = function(args)
				pcall(vim.treesitter.start, args.buf)
			end,
		})
	end,
}
