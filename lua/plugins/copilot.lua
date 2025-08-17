return {
	"zbirenbaum/copilot.lua",
	cmd = "Copilot",
	event = "VimEnter",
	config = function()
		require("copilot").setup({
			panel = {
				enabled = true,
				auto_refresh = false,
				keymap = {
					jump_prev = "[[",
					jump_next = "]]",
					accept = "<CR>",
					refresh = "gr",
					open = "<M-CR>",
				},
				layout = {
					position = "bottom", -- | top | left | right | bottom |
					ratio = 0.4,
				},
			},
			suggestion = {
				enabled = true,
				auto_trigger = true,
				hide_during_completion = false,
				debounce = 75,
				trigger_on_accept = true,
			},
			filetypes = {
				yaml = true,
				markdown = true,
				help = true,
				gitcommit = true,
				gitrebase = true,
				hgcommit = true,
				svn = true,
				cvs = true,
				["."] = true,
			},
			disable_limit_reached_message = false, -- Set to `true` to suppress completion limit reached popup
			root_dir = function()
				return vim.fs.dirname(vim.fs.find(".git", { upward = true })[1])
			end,
		})

		vim.keymap.set("i", "<C-o>", function()
			if require("copilot.suggestion").is_visible() then
				require("copilot.suggestion").accept()
			end
                        require("copilot.suggestion").next()
		end, { desc = "Accept Copilot suggestion (ALL)" })

		vim.keymap.set("i", "<C-j>", function()
			if require("copilot.suggestion").is_visible() then
				require("copilot.suggestion").accept_word()
			end
                        require("copilot.suggestion").next()
		end, { desc = "Accept Copilot suggestion (Word)" })
	end,
}
