return {
	"A7Lavinraj/fyler.nvim",
	dependencies = { "nvim-mini/mini.nvim" },
	config = function()
		local fyler = require("fyler")
		fyler.setup({
			default_explorer = true,
			mappings = {
				["<esc>"] = "CloseView",
				["="] = "GotoCwd",
				["."] = "GotoNode",
				["-"] = "GotoParent",
			},
			git_status = {
				enabled = false,
			},
		})

		vim.keymap.set("n", "<leader>p", fyler.toggle, { desc = "Toggle File Explorer" })

		---@return string, string|nil
		local get_last_dir_under_cursor = function()
			local fyler_explorer = require("fyler.explorer"):current()
			if not fyler_explorer then
				return "", "No active Fyler explorer"
			end

			local ok, current_entry = pcall(function()
				return fyler_explorer:cursor_node_entry()
			end)
			if not (ok and current_entry) then
				return "", "No entry under cursor"
			end

			if current_entry.type == "directory" then
				return current_entry.path or "", nil
			end
			return vim.fn.fnamemodify(current_entry.path or "", ":h"), nil
		end

		vim.api.nvim_create_autocmd({ "BufEnter", "BufNew", "FileType" }, {
			pattern = "*",
			callback = function(ev)
				if vim.bo[ev.buf].filetype ~= "Fyler" then
					return
				end
				vim.cmd("set nocursorcolumn")
				vim.api.nvim_create_autocmd("BufLeave", {
					buffer = ev.buf,
					once = true,
					callback = function()
						vim.cmd("set cursorcolumn")
						vim.keymap.del("n", "<leader>sf", { buffer = ev.buf })
						vim.keymap.del("n", "<leader>sg", { buffer = ev.buf })
						vim.keymap.del("n", "`", { buffer = ev.buf })
					end,
				})

				vim.keymap.set("n", "`", function()
					vim.notify("HERE", vim.log.levels.INFO)
					local dir, err = get_last_dir_under_cursor()
					if err then
						vim.notify(err, vim.log.levels.WARN)
						return
					end

					vim.fn.chdir(dir)
					vim.notify("Changed working directory to " .. dir, vim.log.levels.INFO)

					local fyler_explorer = require("fyler.explorer"):current()
					if not fyler_explorer then
						vim.notify("No active Fyler explorer", vim.log.levels.ERROR)
						return
					end
					fyler.close()
					fyler_explorer:chdir(dir)
					vim.schedule(function()
						fyler.open()
					end)
				end, { desc = "Set working directory to the one under cursor", buffer = ev.buf })

				vim.keymap.set("n", "<leader>sf", function()
					local ignore_patterns = require("utils.file_ignore_patterns")
					local ok, picker = pcall(require, "mini.pick")
					if not ok then
						vim.notify("mini.pick not found", vim.log.levels.ERROR)
						return
					end

					local dir, err = get_last_dir_under_cursor()
					if err then
						vim.notify(err, vim.log.levels.WARN)
						return
					end

					picker.builtin.files({}, { source = { cwd = dir } })
				end, { desc = "Search Files in dir under cursor", buffer = ev.buf })

				vim.keymap.set("n", "<leader>sg", function()
					local ignore_patterns = require("utils.file_ignore_patterns")
					local ok, fzflua = pcall(require, "fzf-lua")
					if not ok then
						vim.notify("fzf-lua", vim.log.levels.ERROR)
						return
					end

					local dir, err = get_last_dir_under_cursor()
					if err then
						vim.notify(err, vim.log.levels.WARN)
						return
					end

					--stylua: ignore
					fzflua.live_grep({ cwd_header = true, cwd = dir, search = "", file_ignore_patterns = ignore_patterns })
				end, { desc = "Search Files in dir under cursor", buffer = ev.buf })
			end,
		})
	end,
}
