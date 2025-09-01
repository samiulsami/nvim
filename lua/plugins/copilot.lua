--- Premium request multipliers (ref: https://docs.github.com/en/copilot/concepts/billing/copilot-requests)
--- GPT-4.1                      0
--- GPT-5 mini                   0
--- GPT-4o                       0
--- Gemini 2.0 Flash             0.25
--- o4-mini                      0.33
--- o3                           1
--- GPT-5                        1
--- Claude Sonnet 3.5            1
--- Claude Sonnet 3.7            1
--- Claude Sonnet 4              1
--- Gemini 2.5 Pro               1
--- Claude Sonnet 3.7 Thinking   1.25
--- Claude Opus 4.1              10
--- Claude Opus 4                10
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
				enabled = not require("utils.llama"):status(),
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

		vim.keymap.set("i", "<C-O>", function()
			if require("copilot.suggestion").is_visible() then
				require("copilot.suggestion").accept()
			end
		end, { desc = "Accept Copilot suggestion (ALL)" })

		vim.keymap.set("i", "<C-o>", function()
			if require("copilot.suggestion").is_visible() then
				require("copilot.suggestion").accept_line()
			end
		end, { desc = "Accept Copilot suggestion (Line)" })

		vim.keymap.set("i", "<C-j>", function()
			if require("copilot.suggestion").is_visible() then
				require("copilot.suggestion").accept_word()
			end
		end, { desc = "Accept Copilot suggestion (Word)" })
	end,
}
