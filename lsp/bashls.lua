-- npm i -g bash-language-server
return {
	cmd = { "bash-language-server", "start" },
	filetypes = { "sh", "bash", "zsh", "make" },
	settings = {
		bashIde = {
			globPattern = "*@(.sh|.inc|.bash|.command)",
		},
	},
}
