return {
	"itchyny/lightline.vim",
	config = function()
		local function trimString(s)
			return s:match("^%s*(.-)%s*$")
		end
		function _G.LightlineShortenedPath()
			local path = vim.fn.expand("%:p")
			local homePattern = "^/*" .. vim.fn.expand("~")
			local prefix = ""

			local colonPos = path:find(":")
			if colonPos then
				prefix = "[" .. path:sub(1, colonPos - 1):upper() .. "]:"
				path = path:sub(colonPos + 1)
			end

			if vim.fn.match(path, homePattern) ~= -1 then
				path = vim.fn.substitute(path, homePattern, "~", "")
			end

			local components = {}
			for _, component in ipairs(vim.split(path, "/")) do
				component = trimString(component)
				if #component > 0 then
					table.insert(components, component)
				end
			end

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

			if vim.bo.modified and #components > 0 then
				components[#components] = components[#components] .. " ●"
			end

			return prefix .. table.concat(components, "/")
		end

		vim.g.lightline = {
			colorscheme = "deus",
			active = {
				left = {
					{ "mode", "paste" },
					{ "gitbranch", "readonly", "shortenedpath" },
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
