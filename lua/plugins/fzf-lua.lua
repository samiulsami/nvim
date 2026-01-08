return {
	"ibhagwan/fzf-lua",
	lazy = false,
	dependencies = {
		"elanmed/fzf-lua-frecency.nvim",
	},
	config = function()
		local frecency = require("fzf-lua-frecency")
		frecency.setup()

		local fzflua = require("fzf-lua")
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
			fzflua.live_grep({ cwd_header = true, cwd = cwd, search = "", file_ignore_patterns = ignore_patterns.get_patterns()})
		end, {desc = "Live Grep"})

		vim.keymap.set("n", "<leader>sj", function()
			local cwd = vim.fn.getcwd()
			fzflua.jumps({cwd_header = false, cwd = cwd, file_ignore_patterns = ignore_patterns.get_patterns() })
		end, {desc = "Search Jumps"})

		vim.keymap.set("n", "<leader>/", function() fzflua.blines({}) end, {desc = "Fuzzy Search Current Buffer Lines"})

		vim.keymap.set("n", "<leader>sq", function()
			local cwd = vim.fn.getcwd()
			fzflua.lgrep_quickfix({
				cwd_header = true,
				cwd = cwd,
				search = "",
				file_ignore_patterns = ignore_patterns.get_patterns(),
			})
		end, {desc = "Live Grep Quickfix List"})

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
