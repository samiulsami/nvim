return {
	"itchyny/lightline.vim",
	config = function()
		vim.cmd([[
			let g:lightline = {
			\ 'colorscheme': 'deus',
			\ 'active': {
			\   'left': [ [ 'mode','paste' ],
			\             [ 'gitbranch', 'readonly', 'filename', 'modified' ] ]
			\ },
			\ 'component_function': {
			\   'gitbranch': 'FugitiveHead'
			\ },
			\ 'mode_map': {
			\ 'n' : 'N',
			\ 'i' : 'I',
			\ 'R' : 'R',
			\ 'v' : 'V',
			\ 'V' : 'VL',
			\ "\<C-v>": 'VB',
			\ 'c' : 'C',
			\ 's' : 'S',
			\ 'S' : 'SL',
			\ "\<C-s>": 'SB',
			\ 't': 'T',
			\ },
			\ }
			]])
	end,
}
