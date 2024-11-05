return {
	{ "nvim-telescope/telescope-dap.nvim" },
	{ -- Fuzzy Finder (files, lsp, etc)
		"nvim-telescope/telescope.nvim",
		event = "VimEnter",
		branch = "0.1.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			{
				"nvim-telescope/telescope-fzf-native.nvim",
				build = "make",
				cond = function()
					return vim.fn.executable("make") == 1
				end,
			},
			{ "nvim-telescope/telescope-ui-select.nvim" },
			{ "nvim-tree/nvim-web-devicons", enabled = vim.g.have_nerd_font },
			{ "folke/flash.nvim" },
		},
		config = function()
			local function flash(prompt_bufnr)
				require("flash").jump({
					-- pattern = "^",
					label = { after = { 0, 0 } },
					search = {
						mode = "search",
						exclude = {
							function(win)
								return vim.bo[vim.api.nvim_win_get_buf(win)].filetype ~= "TelescopeResults"
							end,
						},
					},
					action = function(match)
						local picker = require("telescope.actions.state").get_current_picker(prompt_bufnr)
						picker:set_selection(match.pos[1] - 1)
					end,
				})
			end

			local telescope_setup = {
				defaults = {
					file_ignore_patterns = { "node_modules/*", ".git/*", "vendor/*" },
					history = {
						path = "~/.local/share/nvim/telescope_history.sqlite3",
						limit = 100,
					},
					preview = {
						treesitter = true,
					},
					mappings = {
						n = {
							["<S-p>"] = require("telescope.actions").cycle_history_prev,
							["<S-n>"] = require("telescope.actions").cycle_history_next,
							["s"] = flash,
						},
						i = {
							["<C-s>"] = flash,
						},
					},
				},
				extensions = {
					["ui-select"] = {
						require("telescope.themes").get_dropdown(),
					},
				},
			}

			local current_ignore_patterns = telescope_setup.defaults.file_ignore_patterns
			local ignore_patterns_active = true

			-- Function to toggle ignore patterns globally
			function _G.toggle_ignore_patterns()
				ignore_patterns_active = not ignore_patterns_active
				if ignore_patterns_active then
					current_ignore_patterns = telescope_setup.defaults.file_ignore_patterns
				else
					current_ignore_patterns = {}
				end

				-- Update Telescope defaults without a complete re-setup
				require("telescope").setup({
					defaults = {
						file_ignore_patterns = current_ignore_patterns,
						history = telescope_setup.defaults.history,
						mappings = telescope_setup.defaults.mappings,
						preview = telescope_setup.defaults.preview,
					},
					extensions = telescope_setup.extensions,
				})

				print("Telescope ignore patterns updated to:", vim.inspect(current_ignore_patterns))
			end

			require("telescope").setup(telescope_setup)

			vim.api.nvim_set_keymap(
				"n",
				"<leader>ti",
				":lua toggle_ignore_patterns()<CR>",
				{ noremap = true, silent = true, desc = "[T]oggle [I]gnore patterns" }
			)

			pcall(require("telescope").load_extension, "fzf")
			pcall(require("telescope").load_extension, "ui-select")
			pcall(require("telescope").load_extension, "dap")
			pcall(require("telescope").load_extension, "projects")

			vim.keymap.set("n", "<leader>sp", ":Telescope projects<CR>", { desc = "[S]earch [P]rojects" })

			local builtin = require("telescope.builtin")

			vim.keymap.set("n", "gd", builtin.lsp_definitions, { desc = "[G]oto [D]efinition" })
			vim.keymap.set("n", "gr", builtin.lsp_references, { desc = "[G]oto [R]eferences" })
			vim.keymap.set("n", "gi", builtin.lsp_implementations, { desc = "[G]oto [I]mplementations" })
			vim.keymap.set("n", "<leader>ws", builtin.lsp_dynamic_workspace_symbols, { desc = "[W]orkspace [S]ymbols" })
			vim.keymap.set("n", "<leader>ds", builtin.lsp_document_symbols, { desc = "[D]ocument [S]ymbols" })

			vim.keymap.set("n", "<leader>sh", builtin.help_tags, { desc = "[S]earch [H]elp" })
			vim.keymap.set("n", "<leader>sk", builtin.keymaps, { desc = "[S]earch [K]eymaps" })
			vim.keymap.set("n", "<leader>sf", builtin.find_files, { desc = "[S]earch [F]iles" })
			vim.keymap.set("n", "<C-p>", builtin.git_files, {})
			vim.keymap.set("n", "<leader>ss", builtin.builtin, { desc = "[S]earch [S]elect Telescope" })
			vim.keymap.set("n", "<leader>sw", builtin.grep_string, { desc = "[S]earch current [W]ord" })
			vim.keymap.set("n", "<leader>sg", builtin.live_grep, { desc = "[S]earch by [G]rep" })
			vim.keymap.set("n", "<leader>sd", builtin.diagnostics, { desc = "[S]earch [D]iagnostics" })
			vim.keymap.set("n", "<leader>sn", ":Telescope notify<CR>", { desc = "[S]earch [N]otify" })
			vim.keymap.set("n", "<leader>s.", builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
			vim.keymap.set("n", "<leader><leader>", builtin.buffers, { desc = "[ ] Find existing buffers" })
			vim.keymap.set("n", "<leader>sr", builtin.resume, { desc = "[S]earch [R]esume" })

			vim.keymap.set("n", "<leader>/", function()
				builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
					winblend = 10,
					previewer = true,
				}))
			end, { desc = "[/] Fuzzily search in current buffer" })
			vim.keymap.set("n", "<leader>s/", function()
				builtin.live_grep({
					grep_open_files = true,
					prompt_title = "Live Grep in Open Files",
				})
			end, { desc = "[S]earch [/] in Open Files" })
		end,
	},
}
