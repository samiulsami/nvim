---@type PluginSpec
return {
	src = "https://github.com/ibhagwan/fzf-lua",
	deps = {
		{ src = "https://github.com/elanmed/fzf-lua-frecency.nvim" },
	},
	config = function()
		local frecency = require("fzf-lua-frecency")
		frecency.setup()

		local fzflua = require("fzf-lua")
		local fzflua_config = require("fzf-lua.config")
		local fzflua_core = require("fzf-lua.core")
		local fzflua_make_entry = require("fzf-lua.make_entry")

		local function quickfix_files()
			local paths = {}
			local seen = {}

			for _, item in ipairs(vim.fn.getqflist()) do
				local path = item.filename
				if (not path or path == "") and item.bufnr and item.bufnr > 0 then
					path = vim.api.nvim_buf_get_name(item.bufnr)
				end

				if path and path ~= "" and not seen[path] then
					seen[path] = true
					table.insert(paths, path)
				end
			end

			if #paths == 0 then
				vim.notify("Quickfix list has no files", vim.log.levels.WARN)
				return
			end

			local opts = fzflua_config.normalize_opts({
				cwd_prompt = true,
				cwd_header = true,
				cwd = vim.fn.getcwd(),
				file_ignore_patterns = require("utils.file_ignore_patterns").get_patterns(),
			}, "files")

			local entries = vim.tbl_filter(
				function(entry)
					return entry ~= nil
				end,
				vim.tbl_map(function(path)
					return fzflua_make_entry.file(path, opts)
				end, paths)
			)

			fzflua_core.fzf_exec(entries, opts)
		end

		fzflua.setup({
			ui_select = false,
			"hide",
			winopts = {
				height = 0.8,
				width = 0.8,
				preview = {
					layout = "vertical",
					vertical = "down:50%",
				},
			},
			keymap = {
				fzf = {
					true,
					["ctrl-q"] = "select-all+accept",
				},
			},
		})

		local ignore_patterns = require("utils.file_ignore_patterns")

		-- stylua: ignore start
		vim.keymap.set("n", "<leader>sd", function()
			local cwd = vim.fn.getcwd()
			fzflua.lsp_document_diagnostics({ cwd_header = true, cwd = cwd, file_ignore_patterns = ignore_patterns.get_patterns()})
		end, {desc = "LSP Document Diagnostics"})

		vim.keymap.set("n", "<leader>sD", function()
			local cwd = vim.fn.getcwd()
			fzflua.lsp_workspace_diagnostics({ cwd_header = true, cwd = cwd, file_ignore_patterns = ignore_patterns.get_patterns()})
		end, {desc = "LSP Workspace Diagnostics"})

		vim.keymap.set("n", "<leader>sf", function()
			local cwd = vim.fn.getcwd()
			frecency.frecency({ fzf_opts = { ['--no-sort'] = false }, cwd_prompt = true, cwd_header = true, cwd = cwd, cwd_only = true, all_files = true, display_score = true, file_ignore_patterns = ignore_patterns.get_patterns()})
		end, {desc = "Search Files (frecency)"})

		vim.keymap.set("n", "<leader>fs", function()
			local cwd = vim.fn.getcwd()
			frecency.frecency({ fzf_opts = { ['--no-sort'] = false }, cwd_prompt = true, cwd_header = true, cwd = cwd, cwd_only = true, all_files = false, display_score = true, file_ignore_patterns = ignore_patterns.get_patterns()})
		end, {desc = "Search Frecent Files"})

		vim.keymap.set("n", "<leader>sg", function()
			local cwd = vim.fn.getcwd()
			fzflua.live_grep({ cwd_header = true, cwd = cwd, search = "", hidden = true, no_ignore = true, file_ignore_patterns = ignore_patterns.get_patterns()})
		end, {desc = "Live Grep"})

		vim.keymap.set("n", "<leader>sj", function()
			local cwd = vim.fn.getcwd()
			fzflua.jumps({cwd_header = false, cwd = cwd, file_ignore_patterns = ignore_patterns.get_patterns() })
		end, {desc = "Search Jumps"})

		vim.keymap.set("n", "<leader>/", function() fzflua.blines({}) end, {desc = "Fuzzy Search Current Buffer Lines"})

		vim.keymap.set("n", "<leader>sQ", function()
			local cwd = vim.fn.getcwd()
			fzflua.lgrep_quickfix({
				cwd_header = true,
				cwd = cwd,
				search = "",
				file_ignore_patterns = ignore_patterns.get_patterns(),
			})
		end, {desc = "Live Grep Quickfix List"})

		vim.keymap.set("n", "<leader>sq", quickfix_files, {desc = "Search Quickfix Files List"})

		vim.keymap.set("n", "<leader>sw", function()
			local cwd = vim.fn.getcwd()
			fzflua.lsp_live_workspace_symbols({pwd_header = true, cwd = cwd, file_ignore_patterns = ignore_patterns.get_patterns()})
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

		vim.keymap.set("n", "<leader>gC", function() fzflua.git_bcommits({}) end, {desc = "Git Buffer Commits"})

		vim.keymap.set("n", "<leader>sr", function() fzflua.resume({}) end, {desc = "Search Resume"})
		vim.keymap.set("n", "<leader>so", function() fzflua.oldfiles({}) end, {desc = "Search Oldfiles"})

		vim.keymap.set("n", "<leader>sk", function() fzflua.keymaps({}) end, {desc = "Search Keymaps"})
		vim.keymap.set("n", "<leader>sc", function() fzflua.colorschemes({ winopts = { fullscreen = false } }) end, {desc = "Search Colorschemes"})
		vim.keymap.set("n", "<leader>sh", function() fzflua.help_tags({}) end, {desc = "Search Help Tags"})
		vim.keymap.set("n", "<leader>sH", function() fzflua.highlights({}) end, {desc = "Search Help Tags"})

		-- stylua: ignore end
	end,
}
