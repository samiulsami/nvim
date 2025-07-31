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
			fzflua.lsp_document_diagnostics({cwd_header = true, cwd = cwd, file_ignore_patterns = active_ignore_patterns})
		end, {desc = "LSP Document Diagnostics"})
		vim.keymap.set("n", "<leader>sD", function()
			local cwd = vim.fn.getcwd()
			fzflua.lsp_workspace_diagnostics({cwd_header = true, cwd = cwd, file_ignore_patterns = active_ignore_patterns})
		end, {desc = "LSP Workspace Diagnostics"})
		vim.keymap.set("n", "<leader>sf", function()
			local cwd = vim.fn.getcwd()
			fzflua.files({cwd_header = false, cwd = cwd, file_ignore_patterns = active_ignore_patterns})
		end, {desc = "Search Files"})
		vim.keymap.set("n", "<leader>sg", function()
			local cwd = vim.fn.getcwd()
			fzflua.grep({ cwd_header = true, cwd = cwd, search = "", file_ignore_patterns = active_ignore_patterns})
		end, {desc = "Live Grep"})
		vim.keymap.set("n", "<leader>sj", function()
			local cwd = vim.fn.getcwd()
			fzflua.jumps({cwd_header = false, cwd = cwd, file_ignore_patterns = active_ignore_patterns})
		end, {desc = "Search Jumps"})
		vim.keymap.set("n", "<leader>/", function() fzflua.blines({}) end, {desc = "Fuzzy Search Current Buffer Lines"})
		vim.keymap.set("n", "<leader>sq", function()
			local cwd = vim.fn.getcwd()
			fzflua.lgrep_quickfix({
				cwd_header = true,
				cwd = cwd,
				search = "",
				file_ignore_patterns = active_ignore_patterns,
			})
		end, {desc = "Live Grep Quickfix List"})
		vim.keymap.set("n", "<leader>sw", function()
			local cwd = vim.fn.getcwd()
			fzflua.lsp_live_workspace_symbols({pwd_header = true, cwd = cwd, file_ignore_patterns = active_ignore_patterns})
		end, {desc = "LSP Live Workspace Symbols"})
		vim.keymap.set("n", "<leader>ds", function()
			fzflua.lsp_document_symbols({desc = "LSP Live Document Symbols"})
		end)
		vim.keymap.set("n", "<leader>sp", function() fzflua.zoxide({cwd_header = true}) end, { desc = "Zoxide Directories" })
		pcall(vim.api.nvim_del_keymap, "n", "grt")
		vim.keymap.set("n", "gr", function() fzflua.lsp_references() end, { desc = "LSP References" })
		vim.keymap.set("n", "gd", function() fzflua.lsp_definitions() end, { desc = "LSP Definitions" })
		vim.keymap.set("n", "gi", function() fzflua.lsp_implementations() end, { desc = "LSP Implementations" })
		vim.keymap.set("n", "gD", function() fzflua.lsp_declarations() end, { desc = "LSP Declarations" })

		vim.keymap.set("n", "<leader>GF", function() fzflua.git_files({}) end, {desc = "Git Files"})
		vim.keymap.set("n", "<leader>GD", function() fzflua.git_diff({}) end, {desc = "Git Diff"})
		vim.keymap.set("n", "<leader>GS", function() fzflua.git_stash({}) end, {desc = "Git Stash"})
		vim.keymap.set("n", "<leader>Gc", function() fzflua.git_commits({}) end, {desc = "Git Commits"})
		vim.keymap.set("n", "<leader>GC", function() fzflua.git_bcommits({}) end, {desc = "Git Buffer Commits"})
		vim.keymap.set("n", "<leader>GB", function() fzflua.git_branches({}) end, {desc = "Git Branches"})
		vim.keymap.set("n", "<leader>GT", function() fzflua.git_tags({}) end, {desc = "Git Tags"})

		vim.keymap.set("n", "<leader>sr", function() fzflua.resume({}) end, {desc = "Search Resume"})
		vim.keymap.set("n", "<leader>so", function() fzflua.oldfiles({}) end, {desc = "Search Oldfiles"})

		vim.keymap.set("n", "<leader>sk", function() fzflua.keymaps({}) end, {desc = "Search Keymaps"})
		vim.keymap.set("n", "<leader>sc", function() fzflua.colorschemes({ winopts = { fullscreen = false } }) end, {desc = "Search Colorschemes"})
		vim.keymap.set("n", "<leader>sh", function() fzflua.help_tags({}) end, {desc = "Search Help Tags"})

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
					previewer = nil,
					fzf_opts = {
						['--preview-window'] = "down:60%",
						['--preview'] = function(items)
							local contents = {}
							vim.tbl_map(function(selected)
								if vim.fn.executable("jq") == 0 then
									table.insert(contents, "[jq not found] ".. selected)
								else
									local output = vim.fn.system("jq --color-output", selected)
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
