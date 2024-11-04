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
		},
		config = function()
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
						},
					},
				},
				extensions = {
					["ui-select"] = {
						require("telescope.themes").get_dropdown(),
					},
				},
			}

			-- Store initial ignore patterns and state
			local current_ignore_patterns = telescope_setup.defaults.file_ignore_patterns
			_G.ignore_patterns_active = true -- Use _G to make it global

			-- Function to toggle ignore patterns globally
			function _G.toggle_ignore_patterns()
				-- Toggle the state of ignore patterns
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

			-- Set up Telescope initially
			require("telescope").setup(telescope_setup)

			-- Key mapping to toggle ignore patterns
			vim.api.nvim_set_keymap(
				"n",
				"<leader>ti",
				":lua toggle_ignore_patterns()<CR>",
				{ noremap = true, silent = true, desc = "[T]oggle [I]gnore patterns" }
			)

			-- Enable Telescope extensions if they are installed
			pcall(require("telescope").load_extension, "fzf")
			pcall(require("telescope").load_extension, "ui-select")
			pcall(require("telescope").load_extension, "dap")
			pcall(require("telescope").load_extension, "projects")

			vim.keymap.set("n", "<leader>sp", ":Telescope projects<CR>", { desc = "[S]earch [P]rojects" })

			local builtin = require("telescope.builtin")
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

			vim.keymap.set("n", "<leader>/", function()
				builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
					winblend = 10,
					previewer = false,
				}))
			end, { desc = "[/] Fuzzily search in current buffer" })
			vim.keymap.set("n", "<leader>s/", function()
				builtin.live_grep({
					grep_open_files = true,
					prompt_title = "Live Grep in Open Files",
				})
			end, { desc = "[S]earch [/] in Open Files" })

			vim.keymap.set("n", "<leader>sr", function()
				require("telescope.builtin").resume()
			end, { desc = "[S]earch [R]esume" })
		end,
	},
}
