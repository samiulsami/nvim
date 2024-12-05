return {
	"itchyny/lightline.vim",
	config = function()
		function lightlineGitStatus()
			-- Check if the file is in a Git repository
			if vim.fn.FugitiveHead() == "" then
				return "" -- Not in a Git repository
			end

			-- Get the status of the current file using Fugitive
			local status = vim.fn["FugitiveStatusline"]()

			if status:find("modified") then
				return "[M]" -- Modified file
			elseif status:find("added") then
				return "[A]" -- Added file
			elseif status:find("deleted") then
				return "[D]" -- Deleted file
			elseif status:find("untracked") then
				return "[U]" -- Untracked file
			else
				return "" -- No changes
			end
		end
		function _G.LightlineShortenedPath()
			local path = vim.fn.expand("%:p")
			local home = vim.fn.expand("~")
			if vim.fn.match(path, "^" .. home) ~= -1 then
				path = vim.fn.substitute(path, "^" .. home, "~", "")
			end

			local res = {}
			local components = {}
			for i, component in ipairs(vim.split(path, "/")) do
				component = component:match("^%s*(.-)%s*$")
				if #component > 0 then
					-- if i == 1 then
					-- 	vim.print(component)
					-- end

					if i == 1 and component:sub(-1) == ":" then
						component = "[" .. component:sub(1, #component - 1):upper() .. "]:"
					end
					table.insert(components, component)
				end
			end

			-- for i, component in ipairs(components) do
			-- 	if i >= #components - 1 then
			-- 		break
			-- 	end
			--
			-- 	if component:sub(1, 1) == "." and #component > 1 then
			-- 		components[i] = component:sub(1, 2)
			-- 	else
			-- 		components[i] = component:sub(1, 1)
			-- 	end
			-- end

			if vim.bo.modified and #components > 0 then
				components[#components] = components[#components] .. " ●"
			end

			return table.concat(components, "/")
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
