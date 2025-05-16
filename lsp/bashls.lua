-- npm i -g bash-language-server
return {
	cmd = { "bash-language-server", "start" },
	filetypes = { "bash", "sh", "zsh", "make" },
	root_markers = { ".git" },
	settings = {
		bashIde = {
			globPattern = "*@(.sh|.inc|.bash|.command)",
		},
	},
}
