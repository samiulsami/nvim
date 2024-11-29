return {
	"itchyny/lightline.vim",
	config = function()
		function _G.LightlineShortenedPath()
			local path = vim.fn.expand("%:p")
			local home = vim.fn.expand("~")
			if vim.fn.match(path, "^" .. home) ~= -1 then
				path = vim.fn.substitute(path, "^" .. home, "~", "")
			end
			local components = vim.split(path, "/")
			for i, component in ipairs(components) do
				if i >= #components - 1 then
					break
				end

				if component:sub(1, 1) == "." and #component > 1 then
					components[i] = component:sub(1, 2)
				else
					components[i] = component:sub(1, 1)
				end
			end
			return table.concat(components, "/")
		end

		vim.g.lightline = {
			colorscheme = "deus",
			active = {
				left = {
					{ "mode", "paste" },
					{ "gitbranch", "readonly", "shortenedpath", "modified" },
				},
			},
			component_function = {
				gitbranch = "FugitiveHead",
				shortenedpath = "v:lua.LightlineShortenedPath",
			},
			mode_map = {
				n = "N",
				i = "I",
				R = "R",
				v = "V",
				V = "VL",
				["<C-v>"] = "VB",
				c = "C",
				s = "S",
				S = "SL",
				["<C-s>"] = "SB",
				t = "T",
			},
		}
	end,
}
