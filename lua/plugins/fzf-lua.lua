return {
	"ibhagwan/fzf-lua",
	-- optional for icon support
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		local fzflua = require("fzf-lua")
		fzflua.setup({
			"hide",
			winopts = {
				fullscreen = true,
				preview = {
					layout = "vertical",
					vertical = "down:40%",
				},
			},
			keymap = {
				fzf = {
					true,
					["ctrl-q"] = "select-all+accept",
				},
			},
		})

		local file_ignore_patterns = {
			"node_modules/*",
			"^.git/*",
			"vendor/*",
			"zz_generated*",
			"openapi_generated*",
		}
		local active_ignore_patterns = file_ignore_patterns
		local disable_ignore_patterns = false

		vim.keymap.set("n", "<leader>ti", function()
			if disable_ignore_patterns then
				active_ignore_patterns = file_ignore_patterns
				vim.notify("Set ignore patterns to:\n" .. vim.inspect(active_ignore_patterns))
			else
				vim.notify("Ignore patterns disabled")
				active_ignore_patterns = nil
			end
			disable_ignore_patterns = not disable_ignore_patterns
		end, { desc = "[T]oggle [I]gnore patterns" })

		-- stylua: ignore start
		vim.keymap.set("n", "<leader>sd", function()
			local cwd = vim.fn.getcwd()
			fzflua.lsp_document_diagnostics({cwd_header = true, cwd = cwd, file_ignore_patterns = active_ignore_patterns}, {desc = "LSP Document Diagnostics"})
		end)
		vim.keymap.set("n", "<leader>sD", function()
			local cwd = vim.fn.getcwd()
			fzflua.lsp_workspace_diagnostics({cwd_header = true, cwd = cwd, file_ignore_patterns = active_ignore_patterns}, {desc = "LSP Workspace Diagnostics"})
		end)
		vim.keymap.set("n", "<leader>sf", function()
			local cwd = vim.fn.getcwd()
			fzflua.files({cwd_header = false, cwd = cwd, file_ignore_patterns = active_ignore_patterns}, {desc = "Search Files"})
		end)
		vim.keymap.set("n", "<leader>sg", function()
			local cwd = vim.fn.getcwd()
			fzflua.grep(function() return { cwd_header = true, cwd = cwd, search = "", file_ignore_patterns = active_ignore_patterns} end, {desc = "Live Grep"})
		end)
		vim.keymap.set("n", "<leader>/", function() fzflua.blines({}, {desc = "Fuzzy Search Current Buffer Lines"}) end)
		vim.keymap.set("n", "<leader>sq", function()
			local cwd = vim.fn.getcwd()
			fzflua.lgrep_quickfix(function() return { cwd_header = true, cwd = cwd, search = "", file_ignore_patterns = active_ignore_patterns} end, {desc = "Live Grep Quickfix List"})
		end)
		vim.keymap.set("n", "<leader>ws", function()
			local cwd = vim.fn.getcwd()
			fzflua.lsp_live_workspace_symbols({pwd_header = true, cwd = cwd, file_ignore_patterns = active_ignore_patterns}, {desc = "LSP Live Workspace Symbols"})
		end)
		vim.keymap.set("n", "<leader>ds", function()
			fzflua.lsp_document_symbols({desc = "LSP Live Document Symbols"})
		end)
		vim.keymap.set("n", "<leader>sp", function() fzflua.zoxide({cwd_header = true}) end, { desc = "Zoxide Directories" })
		pcall(vim.api.nvim_del_keymap, "n", "grt")
		vim.keymap.set("n", "gr", function() fzflua.lsp_references() end, { desc = "LSP References" })
		vim.keymap.set("n", "gd", function() fzflua.lsp_definitions() end, { desc = "LSP Definitions" })
		vim.keymap.set("n", "gi", function() fzflua.lsp_implementations() end, { desc = "LSP Implementations" })
		vim.keymap.set("n", "gD", function() fzflua.lsp_declarations() end, { desc = "LSP Declarations" })

		vim.keymap.set("n", "<leader>gs", function() fzflua.git_stash({}, {desc = "Git Stash"}) end)
		vim.keymap.set("n", "<leader>sr", function() fzflua.resume({}, {desc = "Search Resume"}) end)
		vim.keymap.set("n", "<leader>so", function() fzflua.oldfiles({}, {desc = "Search Oldfiles"}) end)

		vim.keymap.set("n", "<leader>sk", function() fzflua.keymaps({}, {desc = "Search Keymaps"}) end)
		vim.keymap.set("n", "<leader>sh", function() fzflua.help_tags({}, {desc = "Search Help Tags"}) end)

		local notification_util = require("utils.notifications")
		vim.keymap.set("n", "<leader>sn", function()
			fzflua.fzf_exec(coroutine.wrap(function(fzf_cb)
				local notifications, head, tail = notification_util:get_notifications()
				if not notifications then return end
				local counter = tail - head + 1
				local co = coroutine.running()
				for i = tail, head, -1 do
					vim.schedule(function()
						fzf_cb(
							notifications[i],
							function() coroutine.resume(co) end
						)
						counter = counter - 1
					end)
					coroutine.yield()
				end
				fzf_cb()
				notification_util:reset_unseen_notifications()
			end), {
					actions = {
						["ctrl-q"] = function(selected, _)
							local buf = vim.api.nvim_create_buf(false, true)
							vim.api.nvim_buf_set_lines(buf, 0, -1, false, selected)
							vim.api.nvim_set_current_buf(buf)
							vim.cmd("set ft=json")
						end,
					},
					previewer = false,
					fzf_opts = {
						['--preview-window'] = "down:60%",
						['--preview'] = function(items)
							local contents = {}
							vim.tbl_map(function(selected)
								if vim.fn.executable("jq") == 0 then
									table.insert(contents, "[jq not found] ".. selected)
								else
									local output = vim.fn.system("echo '" .. selected .. "' | jq --color-output")
									if vim.v.shell_error ~= 0 then
										table.insert(contents, "Invalid JSON, or jq error: ".. selected)
									else
										table.insert(contents, output)
									end
								end
							end, items)
							return contents
						end
					},
				})
		end, {desc = "Notification History" })
		-- stylua: ignore end
	end,
}
